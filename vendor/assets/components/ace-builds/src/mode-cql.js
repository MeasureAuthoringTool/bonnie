define('ace/mode/cql', [], function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var TextMode = require("./text").Mode;
var Tokenizer = require("../tokenizer").Tokenizer;

var CQLHighlightRules = require("./mode-cql_highlight_rules").CQLHighlightRules;

var Mode = function() {
    this.HighlightRules = CQLHighlightRules;
};
oop.inherits(Mode, TextMode);

(function() {
    this.lineCommentStart = "//";
    this.blockComment = {start: "/*", end: "*/"};
}).call(Mode.prototype);

exports.Mode = Mode;
});