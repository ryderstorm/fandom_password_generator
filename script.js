function copyToClipboard(element) {
  var $temp = $("<input>");
  $("body").append($temp);
  $temp.val($(element).text()).select();
  document.execCommand("copy");
  $temp.remove();
}

function copyToClipboardLowercase(element) {
  var $temp = $("<input>");
  $("body").append($temp);
  $temp.val($(element).text().toLowerCase()).select();
  document.execCommand("copy");
  $temp.remove();
}
