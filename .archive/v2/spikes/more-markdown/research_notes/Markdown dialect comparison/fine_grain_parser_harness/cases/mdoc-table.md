{% table %}
* Heading 1 {% align="center" %}
* Heading 2
---
* Row 1 Cell 1 {% colspan=2 %}
---
* Cell with list:
  - a
  - b
* {% rowspan=2 %} x
---
* last
{% /table %}

Text with a break  
here and `typography` "quotes" -- ...

{% partial file="header.md" /%}
