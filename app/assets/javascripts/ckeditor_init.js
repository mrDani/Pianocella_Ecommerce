document.addEventListener("DOMContentLoaded", function () {
    const textarea = document.getElementById("ckeditor-content");
    if (textarea) {
      ClassicEditor
        .create(textarea)
        .catch(error => {
          console.error(error);
        });
    }
  });
  