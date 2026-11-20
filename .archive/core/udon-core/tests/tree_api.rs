//! Host-view API tests (CORE "Host Views (Recommended)", "Attribute
//! Stacking"): both views derive from the full ordered attribute substrate.

use udon_core::tree::{Document, Value};

#[test]
fn key_and_traits_views() {
    let doc = Document::parse(b"|article[intro].featured.draft :author Joseph\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();

    assert_eq!(el.name(), "article");
    assert!(!el.is_anonymous());
    assert_eq!(el.key().and_then(|v| v.as_str()), Some("intro"));

    // traits is ALWAYS a list, in document order
    let traits: Vec<_> = el.traits().iter().map(|v| v.as_str().unwrap()).collect();
    assert_eq!(traits, ["featured", "draft"]);
    assert!(el.has_trait("featured"));
    assert!(!el.has_trait("nope"));

    // attributes() excludes the designated ones; all_attributes() has all,
    // in document order
    let plain: Vec<_> = el.attributes().map(|(n, _)| n).collect();
    assert_eq!(plain, ["author"]);
    let all: Vec<_> = el.all_attributes().map(|(n, _)| n).collect();
    assert_eq!(all, ["$key", "$traits", "$traits", "author"]);
}

#[test]
fn longhand_designated_attr_is_identity() {
    // CORE "Identity": a generator writing :'$key' 3890 longhand IS an
    // identity, indistinguishable from |el[3890].
    let doc = Document::parse(b"|el :'$key' 3890\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    assert!(matches!(el.key(), Some(Value::Integer(s)) if s == "3890"));
}

#[test]
fn typed_keys() {
    let doc = Document::parse(b"|item[1]\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    assert!(matches!(el.key(), Some(Value::Integer(s)) if s == "1"));

    let doc = Document::parse(b"|item[\"01\"]\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    assert!(matches!(el.key(), Some(Value::String(s)) if s == "01"));
}

#[test]
fn suffix_flags() {
    let doc = Document::parse(b"|field[name]?\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    assert!(el.has_flag("$?"));
    assert!(!el.has_flag("$!"));
}

#[test]
fn anonymous_elements() {
    let doc = Document::parse(b"|.defaults :adapter pg\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    assert!(el.is_anonymous());
    assert!(el.has_trait("defaults"));
    assert_eq!(el.attr("adapter").and_then(|v| v.as_str()), Some("pg"));
}

#[test]
fn attribute_stacking_scalar_is_last() {
    // CORE "Attribute Stacking": every assignment kept in order; the
    // scalar accessor returns the LAST, attr_all returns all.
    let doc = Document::parse(b"|el :x 1 :x 2\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    assert!(matches!(el.attr("x"), Some(Value::Integer(s)) if s == "2"));
    let all = el.attr_all("x");
    assert_eq!(all.len(), 2);
    assert!(matches!(all[0], Value::Integer(s) if s == "1"));
    assert!(matches!(all[1], Value::Integer(s) if s == "2"));
}

#[test]
fn stacking_and_lists_are_orthogonal() {
    let doc = Document::parse(b"|el :x [1 2] :x [3]\n").unwrap();
    let el = doc.root().first_child().unwrap().as_element().unwrap();
    let all = el.attr_all("x");
    assert_eq!(all.len(), 2);
    assert!(matches!(all[0], Value::Array(items) if items.len() == 2));
    assert!(matches!(all[1], Value::Array(items) if items.len() == 1));
}
