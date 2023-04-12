const docHTML = document.getElementById('doc-html')
docHTML.querySelectorAll('pre code').forEach((block) => {
  hljs.highlightBlock(block);
});