# frozen_string_literal: true

module Mutant
  module AST
    # Groups of node types
    module Types
      ASSIGNABLE_VARIABLES = Set.new(%i[ivasgn lvasgn cvasgn gvasgn]).freeze

      # Set of op-assign types
      OP_ASSIGN              = Set.new(%i[or_asgn and_asgn op_asgn]).freeze
      # Set of node types that are not valid when emitted standalone
      NOT_STANDALONE         = Set.new(%i[splat restarg block_pass]).freeze
      INDEX_OPERATORS        = Set.new(%i[[] []=]).freeze
      UNARY_METHOD_OPERATORS = Set.new(%i[~@ +@ -@ !]).freeze

      # Operators ruby implements as methods
      METHOD_OPERATORS = Set.new(%i[
        !
        !=
        !~
        %
        &
        *
        **
        +
        +@
        -
        -@
        /
        <
        <<
        <=
        <=>
        ==
        ===
        =~
        >
        >=
        >>
        []
        []=
        ^
        |
        ~@
      ]).freeze

      BINARY_METHOD_OPERATORS = Set.new(
        METHOD_OPERATORS - (INDEX_OPERATORS + UNARY_METHOD_OPERATORS)
      )

      # Nodes that are NOT handled by mutant.
      #
      # not - 1.8 only, mutant does not support 1.8
      #
      BLACKLIST = Set.new(%i[not]).freeze

      # Nodes that are NOT generated by parser but used by mutant / unparser.
      GENERATED = Set.new(%i[empty]).freeze

      ALL = Set.new(
        (Parser::Meta::NODE_TYPES + GENERATED) - BLACKLIST
      ).freeze
    end # Types
  end # AST
end # Mutant
