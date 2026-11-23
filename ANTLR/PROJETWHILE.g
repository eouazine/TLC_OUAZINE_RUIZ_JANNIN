grammar PROJETWHILE;

options { output=AST; } //Crée un arbre AST

//tokens
VARIABLE
	:	MAJ (MAJ | MIN | DEC)* ('!' | '?')?;
SYMBOL
	:	MIN (MAJ | MIN | DEC)* ('!' | '?')?;
WS
	:	(' ' | '\t' | '\r' | '\n')+ { $channel = HIDDEN; };
COMMENT
	:	'//' ~('\n' | '\r')* { $channel = HIDDEN; };

//règles

program	
	:	function+ EOF!;
function
    : 'function'^ SYMBOL ':'! definition;
definition
    : 'read' input bloc='%' commands '%' 'write' output
      -> ^('read' input?) ^($bloc commands) ^('write' output);
input	
	:	inputsub?;
inputsub
    : VARIABLE (','! inputsub)?;
output
    : VARIABLE (','! output)?;
commands
	:	command(';'! commands)?;
command
	:	'nop'
	|	vars ':=' exprs -> ^(':=' vars exprs)
	|   'if' expression 'then' oui=commands ('else' non=commands)? 'fi' -> ^('if' expression ^('then' $oui) ^('else' $non)?)
	|	'while' expression 'do' commands 'od' -> ^('while' expression ^('do' commands))
	|	'for' expression 'do' commands 'od' -> ^('for' expression ^('do' commands))
	|	'foreach' VARIABLE 'in' expression 'do' commands 'od' -> ^('foreach' VARIABLE expression ^('do' commands));

vars
	:	VARIABLE(','^ vars)?;

exprs
	:	expression(','^ exprs)?;

exprbase
    : 'nil' | VARIABLE | SYMBOL
    | '('! 'cons'^ lexpr ')'!
    | '('! 'list'^ lexpr ')'!
    | '('! 'hd'^ exprbase ')'!
    | '('! 'tl'^ exprbase ')'!
    | '('^ SYMBOL lexpr ')'!;

expression
	:	exprbase('=?'^ exprbase)?;

lexpr
	:	(exprbase lexpr)?;
	
//FRAGMENTS
fragment MAJ
	:	 ('A'..'Z');
fragment MIN
	:	 ('a'..'z');
fragment DEC
	:	 ('0'..'9');


