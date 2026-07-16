fn main() {
    udon_core::Parser::new(b"|el :a?\n").parse(|e| println!("{}", e.format_line()));
}
