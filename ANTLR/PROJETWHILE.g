grammar PROJETWHILE;

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
	:	function+ EOF;
function
	:	'function'SYMBOL':'definition;
definition
	:	'read'input'%'commands'%''write'output;
input	
	:	inputsub?;
inputsub
	:	VARIABLE','inputsub|VARIABLE;
output
	:	VARIABLE','output|VARIABLE;
commands
	:	command(';'commands)?;
command
	:	'nop'
	|	vars ':=' exprs
	|	'if' expression 'then' commands ('else' commands)? 'fi'
	|	'while' expression 'do' commands 'od'
	|	'for' expression 'do' commands 'od'
	|	'foreach' VARIABLE 'in' expression 'do' commands 'od';

vars
	:	VARIABLE(','vars)?;

exprs
	:	expression(','exprs)?;

exprbase
	:	'nil'|VARIABLE|SYMBOL
	|	'(''cons'lexpr')'|'(''list'lexpr')'
	|	'(''hd'exprbase')'|'(''tl'exprbase')'
	|	'('SYMBOL lexpr')';

expression
	:	exprbase('=?'exprbase)?;

lexpr
	:	(exprbase lexpr)?;
	
//FRAGMENTS
fragment MAJ
	:	 ('A'..'Z');
fragment MIN
	:	 ('a'..'z');
fragment DEC
	:	 ('0'..'9');


