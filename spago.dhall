{ name = "halogen-project"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "affjax"
  , "argonaut"
  , "argonaut-core"
  , "console"
  , "effect"
  , "either"
  , "foreign-object"
  , "halogen"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "strings"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
