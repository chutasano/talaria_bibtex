

%token <string> WORD
%token <int> NUM
%token COMMA, MINUS, AND, EOF, SEP

%{
open Field_types
%}

%type <Field_types.name list> names
%type <string list> tags
%type <Field_types.pages> pages
%type <string list> path
%start pages tags names path

%%

%public pages:
	| l=NUM EOF{ Loc l }
	| WORD l=NUM EOF{Loc l}
	| l=NUM MINUS u=NUM EOF{Interv (l,u)}

%public tags:
	| t=WORD EOF {[t]}
	| t=WORD COMMA ts=tags {t::ts}

%public names:
	| n=name EOF {[n]}
	| n=name AND ns=names {n::ns} 

name:
	| lastname=WORD COMMA firstname=WORD  { {firstname; lastname} }

%public path:
	| w=WORD EOF {[w]}
	| w=WORD SEP p=path {w::p}