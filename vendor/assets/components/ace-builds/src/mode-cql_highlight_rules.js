define("ace/mode/cql_highlight_rules",["require","exports","module","ace/lib/oop","ace/mode/text_highlight_rules"], function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;

var CqlHighlightRules = function() {

 var keywords = (
            "library|version|using|include|called|public|private|parameter|default|valueset|"+
            "codesystems|List|Interval|Tuple|define|context|function|with|such|that|in|from|"+
            "where|return|all|distinct|sort|by|asc|ascending|desc|descending|not|is|as|cast|"+
            "exists|properly|between|and|difference|matches|contains|or|xor|union|intersect|"+
            "except|year|month|day|minute|hour|second|millisecond|date|time|timezone|years|"+
            "months|days|minutes|hours|seconds|milliseconds|convert|to|start|end|of|duration|"+
            "width|successor|predecessor|singleton|minimum|maximum|if|then|else|div|mod|case|"+
            "collapse|expand|when|then|before|after|more|less|occurs|same|included|overlaps|"+
            "display|Code|Concept|starts|ends"
        );

        var langConstant = (
            "true|false|null"
        );

        var keywordMapper = this.createKeywordMapper({
            "keyword": keywords,
            "constant.language": langConstant
        }, "identifier");

        var functionRule = {
            token: ["paren.lparen", "variable.parameter", "paren.rparen", "text", "storage.type"],
            regex: /(?:(\()((?:"[^")]*?"|'[^')]*?'|\/[^\/)]*?\/|[^()\"'\/])*?)(\))(\s*))?([\-=]>)/.source
        };
        var identifierReg = "[_a-zA-Z][_a-zA-Z0-9]*"
        var fqmodelType = identifierReg+"\\."+identifierReg 
        var model = "("+identifierReg+"\\.?"+identifierReg+")"
        var vs = "\\\"[^\s]*\\\""
        var rstart = "(\\[)"
        var spaces = "(\\s*)"
        var ret = rstart+spaces+model+spaces+"(\:)?"+spaces+"("+identifierReg+")?(\s+in)?"
        console.log(ret)
        var stringEscape = /\\(?:x[0-9a-fA-F]{2}|u[0-9a-fA-F]{4}|[0-2][0-7]{0,2}|3[0-6][0-7]?|37[0-7]?|[4-7][0-7]?|.)/;
        this.$rules = {
            "start" : [
                {token : "quotedIdentifier", regex : /\"/, next  : "quotedIdentifier"},
                {token : "string", regex : "'", next  : "qstring"},
               // {token : "retrieve", regex : /\[.*\]/},
                //{token : "dt", regex : /\@\T[0-9][0-9](\:[0-9][0-9])?/},
                //{token : "date" , regex : /\@\T[0-9][0-9] (\:[0-9][0-9] (\:[0-9][0-9] ('.'[0-9]+)?)?)?(\Z | (('+' | '-') [0-9][0-9]\:[0-9][0-9]))?/},
                {token : "doc.comment", regex : /\/\*.+/, next: "comment"},
                {token : "comment",  regex : /\/\/.+$/},
                {token : "invalid", regex: "\\.{2,}"},
                {token: "emptyBrackets", regex: /\[\s*\]/},
                {token: ["keyword","bracket.lbracket"], regex: /(Interval\s*)(\[)/},
                {token: ["identifier","bracket.lbracket"], regex: /([_a-zA-Z][_a-zA-Z0-9]*)(\[)/},
                {token: ["retrieve.start","text", "model","text","colon","text", "path","text"], regex: ret, next: "start"},
                {token : "keyword.operator", regex: /\W[\-+\%=<>*]\W|\*\*|[~:,\.&$]|->*?|=>/},
                {token : "retrieve.start", regex : /\[/},
                {token : "bracket.rbracket", regex : /\]/},
                {token : "paren.lparen", regex : "[\\({]"},
                {token : "paren.rparen", regex : "[\\)}]"},
                {token : "constant.numeric", regex: "[+-]?\\d+\\b"},

                {token : "variable.parameter", regex : /sy|pa?\d\d\d\d\|t\d\d\d\.|innnn/}, 
                //{token : "keyword", regex : compoundKeywords}, 
                {token : "variable.parameter", regex : /\w+-\w+(?:-\w+)*/}, 
                {token : keywordMapper, regex : "\\b\\w+\\b"},
                {caseInsensitive: true}
            ],
            "qstring" : [
                {token : "constant.language.escape",   regex : "''"},
                {token : "string", regex : "'",     next  : "start"},
                {defaultToken : "string"}
            ],
            "quotedIdentifier" : [

                {token : "constant.language.escape",   regex :/\\\"/},
                {token : "quotedIdentifier", regex : /\"/,next: "start"},
                {defaultToken : "quotedIdentifier"}
            ]
            ,
            "comment" : [
                {token : "doc.comment", regex : /\*\//,     next  : "start"},
                {defaultToken : "doc.comment"}

            ],

            "libraryDef" : [
                {token : "comment",  regex : /\/\/.+$/},
                {token: ""}
            ]
        };

      this.normalizeRules();
    }
oop.inherits(CqlHighlightRules, TextHighlightRules);
exports.CqlHighlightRules = CqlHighlightRules;

});