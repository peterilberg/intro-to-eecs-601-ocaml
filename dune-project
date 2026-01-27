(lang dune 3.20)

(name eecs601)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name eecs601)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
   ocaml
   ppx_deriving
   (mdx :with-test))
 (tags
  ("add topics" "to describe" your project)))

(using mdx 0.2)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
