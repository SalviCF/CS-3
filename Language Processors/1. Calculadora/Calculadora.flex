// UserCode ////////////////////////////////////////////////////////////////////////////////////

import java_cup.runtime.*; 

%%
// Options and declarations ////////////////////////////////////////////////////////////////////

%cup

LineTerminator = \r|\n|\r\n
// WhiteSpace = {LineTerminator} | [ \t\f]
Number = 0|[1-9][0-9]*

%%
// Lexical rules //////////////////////////////////////////////////////////////////////////////

{Number}            { return new Symbol(sym.NUM, new Integer(yytext())); } // tiene valor, retorna un Integer
\+                  { return new Symbol(sym.MAS); }
\-                  { return new Symbol(sym.MENOS); }
\*                  { return new Symbol(sym.POR); }
\/                  { return new Symbol(sym.DIV); }
\(                  { return new Symbol(sym.PI); }
\)                  { return new Symbol(sym.PD); }
{LineTerminator}    { return new Symbol(sym.LT); }
[^]                 { /* ignorar */ }  

