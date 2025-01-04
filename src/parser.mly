%token <string> TEXT
%token <string> KIND
%token LCURL COMMA RCURL EQUAL EOF


%nonassoc LCURL RCURL
%left COMMA EQUAL

%type < Fields.raw_entry Fields.Database.t> main
%start main

%{
  let add raw_entry database = Fields.Database.add raw_entry.Fields.uid raw_entry database
%}

%%

%public main:
	| entry=entry d=main { add entry d}
	| EOF {Fields.Database.empty}

entry:
	| kind=KIND LCURL name=TEXT COMMA e=properties RCURL
	{ {Fields.uid=name; kind; raw=e} }

properties:
	| key=TEXT EQUAL LCURL p=rtext RCURL COMMA e=properties
	  { Fields.Database.add (String.trim key) p e }
	| key=TEXT EQUAL LCURL p=rtext RCURL opt_comma
	  { Fields.Database.singleton (String.trim key) p }
        | key=TEXT EQUAL p=rtext_nobrk COMMA e=properties
	  { Fields.Database.add (String.trim key) p e }
        | key=TEXT EQUAL p=rtext_nobrk opt_comma
	  { Fields.Database.singleton (String.trim key) p }

opt_comma:
	| 	{()}
	| COMMA {()}

rtext:
	| s=TEXT {s}
	| rs1=rtext EQUAL rs2=rtext {rs1 ^ "=" ^ rs2}
	| rs1=rtext COMMA rs2=rtext  {rs1 ^ "," ^ rs2 }
	| rs1=rtext LCURL rs2=rtext RCURL rs3=rtext {rs1 ^ rs2 ^ rs3 }
	| LCURL rs=rtext RCURL { rs }

(* TODO not sure if this captures all non-bracket wrapped values -- might need to support = and , for example *)
rtext_nobrk:
        | s=TEXT {s}
