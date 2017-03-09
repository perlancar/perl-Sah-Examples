package Sah::Examples;

# DATE
# VERSION

1;
# ABSTRACT: Example Sah schemas

=head1 DESCRIPTION

This distribution contains various examples of L<Sah> schemas in its per-dist
share dir.

This POD also contains examples of schemas.

=head1 EXAMPLES

The examples are written in JSON with Javascript-style comments (C<// comment>).

=head2 Simple

 # integer, optional
 "int"

 // required integer
 "int*"

 // same thing
 ["int", {"req": 1}]

 // integer between 1 and 10
 ["int*", {"min": 1, "max": 10}]

 // same thing, the curly brace is optional (unless for advanced stuff)
 ["int*", "min", 1, "max", 10]

 // array of integers between 1 and 10
 ["array*", {"of": ['int*', "between": [1, 10]]}]

 // a byte (let's assign it to a new type 'byte')
 ["int", {"between": [0,255]}]

 // a byte that's divisible by 3
 ["byte", {"div_by": 3}]

 // a byte that's divisible by 3 *and* 5
 ["byte", {'div_by&": [3, 5]}]

 // a byte that's divisible by 3 *or* 5
 ["byte", {"div_by|": [3, 5]}]

 // a byte that's *in*divisible by 3
 ["byte", {"!div_by": 3}]


=head2 Clause attribute

=head2 Coercion rule

Explicitly enable rule(s) that is (are) not enabled by default:

 // allow input as comma-separated string, e.g. "1,20,3,4"
 ["array", {"of": "int", "x.perl.coerce_rules": ["str_comma_sep"]}]

Explicitly disable rule(s) that is (are) enabled by default:

 // don't allow duration to be coerced from integer (number of seconds)
 ["duration", {"x.perl.coerce_rules": ["!float_secs"]}]

=head2 Expression

=head2 Function

=head2 Merging

 // an address hash (let's assign it to a new type called 'address')
 ["hash", {
     // recognized keys
     "keys": {
         "line1":    ["str*", {"max_len": 80}],
         "line2":    ["str*", {"max_len": 80}],
         "city":     ["str*", {"max_len": 60}],
         "province": ["str*", {"max_len": 60}],
         "postcode": ["str*", {"len_between": [4, 15], "match": "^[\w-]{4,15}$"}],
         "country":  ["str*", {"len": 2, "match": "^[A-Z][A-Z]$"}]
     },
     // keys that must exist in data
     "req_keys": ["line1", "city", "province", "postcode", "country"]
  ]

  // a US address, let's base it on 'address' but change 'postcode' to
  // 'zipcode'. also, require country to be set to 'US'
  ["address", {
      "merge.subtract.keys": {"postcode": null},
      "merge.normal.keys": {
          "zipcode": ["str*", "len", 5, "match", "^\d{5}$"],
          "country": ["str*", "is", "US"]
      },
      "merge.subtract.req_keys": ["postcode"],
      "merge.add.req_keys": ["zipcode"]
  ]


=head1 SEE ALSO

L<Sah> specification, which contains a spectest in its per-dist share dir.

L<Data::Sah>, Perl implementation for Sah.

L<Data::Sah::Coerce> for more information about coercion.

Various C<Sah::Schema::*> modules (in C<Sah::Schema::*> or C<Sah::Schemas::*>
distributions) which contain schemas in Perl modules.
