#!/usr/bin/env ruby
# frozen_string_literal: true

# Tangle Alloy 6 blocks from spec/alloy-def/*.md (in spec/alloy.outline.md order)
# and execute every `check` and `run` against Alloy 6.
#
# Usage:
#   ruby spec/alloy-def/verify.rb
#   ALLOY_JAR=/path/to/alloy.jar ruby spec/alloy-def/verify.rb

require "fileutils"
require "open3"
require "tmpdir"

SPEC_DIR = File.expand_path("..", __dir__)
OUTLINE  = File.join(SPEC_DIR, "alloy.outline.md")

JAVA = ENV.fetch("JAVA", "/opt/homebrew/opt/openjdk/bin/java")
ALLOY_JAR = ENV.fetch(
  "ALLOY_JAR",
  File.expand_path("~/src/verisectorium/msc/scratch/spike-formal-perspectives-2026-11-10/alloy/tool/alloy.jar")
)

abort "Alloy jar not found at #{ALLOY_JAR} (set ALLOY_JAR=...)" unless File.exist?(ALLOY_JAR)
abort "Java not found at #{JAVA} (set JAVA=...)" unless File.exist?(JAVA)

# Discover alloy-def/*.md files in outline order via [[alloy-def/<name>|...]] links
outline_text = File.read(OUTLINE)
def_files = outline_text.scan(/\[\[alloy-def\/([^\]|\\]+)/).flatten.uniq.map do |slug|
  path = File.join(SPEC_DIR, "alloy-def", "#{slug}.md")
  abort "Outline links to missing file: #{path}" unless File.exist?(path)
  path
end

abort "No alloy-def/*.md links found in #{OUTLINE}" if def_files.empty?

normative = []
checks    = []
examples  = []

def_files.each do |path|
  rel = path.sub("#{SPEC_DIR}/", "")
  lines = File.readlines(path)
  in_fence = false
  role = nil
  buf = []
  start_line = nil

  lines.each_with_index do |line, idx|
    if !in_fence && line =~ /^```alloy(?:\s+(\S+))?\s*$/
      in_fence = true
      role = $1 || "normative"
      buf = []
      start_line = idx + 2
    elsif in_fence && line =~ /^```\s*$/
      header = "// --- #{rel}:#{start_line} (#{role}) ---\n"
      chunk = header + buf.join
      case role
      when "normative" then normative << chunk
      when "check"     then checks    << chunk
      when "eg"        then examples  << chunk
      when "alt"       then nil # exploratory alternative; skipped in main run
      else
        abort "Unknown alloy fence tag '#{role}' at #{rel}:#{start_line - 1}"
      end
      in_fence = false
      role = nil
    elsif in_fence
      buf << line
    end
  end
end

assembled = (normative + ["\n// === CHECKS & NON-VACUITY GUARDS ===\n"] + checks +
             ["\n// === E.g. EXAMPLES ===\n"] + examples).join("\n")

Dir.mktmpdir("udon-alloy-") do |dir|
  als_path = File.join(dir, "udon_core.als")
  out_dir  = File.join(dir, "out")
  File.write(als_path, assembled)

  puts "Assembled #{def_files.size} files -> #{assembled.lines.size} lines of Alloy 6:"
  def_files.each { |f| puts "  - #{f.sub("#{SPEC_DIR}/", "")}" }
  puts

  cmd = [JAVA, "-jar", ALLOY_JAR, "exec", "-f", "-o", out_dir, "-t", "text", "-s", "glucose", als_path]
  stdout, stderr, status = Open3.capture3(*cmd)

  unless status.success?
    warn "Alloy execution failed (exit #{status.exitstatus}):"
    warn stdout unless stdout.empty?
    warn stderr unless stderr.empty?
    warn "\nAssembled file saved to /tmp/udon_core_failed.als for inspection."
    File.write("/tmp/udon_core_failed.als", assembled)
    exit 1
  end

  results = []
  cur = nil
  (stdout + "\n" + stderr).each_line do |line|
    if line =~ /^\s*(\d+)\.\s+(check|run)\s+(\S+)(.*)$/
      cur = { idx: $1, kind: $2, name: $3, status: nil }
      tail = $4
      cur[:status] = $1 if tail =~ /\b(SAT|UNSAT)\b/
      results << cur
    elsif cur && cur[:status].nil? && line =~ /\b(SAT|UNSAT)\b/
      cur[:status] = $1
    end
  end

  if results.empty? || results.any? { |r| r[:status].nil? }
    warn "DEBUG: raw Alloy output (some statuses were nil):"
    warn "STDOUT:\n#{stdout}"
    warn "STDERR:\n#{stderr}"
    exit 1
  end

  failures = 0
  results.each do |r|
    ok = (r[:kind] == "check" && r[:status] == "UNSAT") ||
         (r[:kind] == "run"   && r[:status] == "SAT")
    verdict =
      if r[:kind] == "check"
        ok ? "PASS (no counterexample)" : "FAIL (COUNTEREXAMPLE FOUND!)"
      else
        ok ? "PASS (witness found)" : "FAIL (UNSAT / vacuous!)"
      end
    failures += 1 unless ok
    printf "  %-6s %-34s -> %s\n", r[:kind], r[:name], verdict
  end

  puts "\nTotal: #{results.size} commands (#{failures} failures)"
  exit(failures == 0 ? 0 : 1)
end
