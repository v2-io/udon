fn main() {
    for input in [
        "|el\n  :theta\n    :first 1\n",                       // attr_under_attr (panic-only!)
        "|el\n  :omega <val>\n    ; just a note\n",            // deeper comment
        "|el\n  :a 1\n  :a |node\n  :a more text\n",           // heterogeneous
        "|nav |{a :href / Home} |{a :href /about About}\n",    // multiple_embedded
        "|el :a 1 and a tail\n  :b 2\n",                       // forecloses
    ] {
        println!("=== {:?}", input);
        udon_core::Parser::new(input.as_bytes()).parse(|e| println!("  {}", e.format_line()));
    }
}
