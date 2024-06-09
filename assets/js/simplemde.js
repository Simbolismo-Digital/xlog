// Handle the simplemde editor content and post data

import SimpleMDE from "../vendor/simplemde/simplemde.min.js"

function getGoogleDriveFileId(url) {
    const regex = /\/d\/([a-zA-Z0-9_-]+)\//;
    const match = url.match(regex);
    return match ? match[1] : null;
}
  
function getYouTubeVideoID(url) {
    const regex = /[?&]v=([^#\&\?]+)/;
    const match = url.match(regex);
    return match ? match[1] : null;
}

export default function setupSimpleMDE(liveSocket) {

  liveSocket.hooks.simpleMDE = {
      mounted() {
        // Set content in the editor
        document.getElementById("markdown-editor-title").value = localStorage.getItem("markdown-editor-title") || "";
  
        // Listen for changes in the input field and save to localStorage
        document.getElementById("markdown-editor-title").addEventListener("input", function() {
          var content = this.value;
          localStorage.setItem("markdown-editor-title", content);
        });
        
        const savedContent = localStorage.getItem("markdown-editor-content") || "";
        const simplemde = new SimpleMDE({
          element: this.el,
          autofocus: true,
          initialValue: savedContent,
          spellChecker: false,
          status: false,
          forceSync: true,
          toolbar: [
            {
              name: "negrito",
              action: SimpleMDE.toggleBold,
              className: "fa fa-bold",
              title: "Negrito",
            },
            {
              name: "itálico",
              action: SimpleMDE.toggleItalic,
              className: "fa fa-italic",
              title: "Itálico",
            },
            {
              name: "título",
              action: SimpleMDE.toggleHeadingSmaller,
              className: "fa fa-header",
              title: "Título",
            },
            "|",
            {
              name: "citação",
              action: SimpleMDE.toggleBlockquote,
              className: "fa fa-quote-left",
              title: "Citação",
            },
            {
              name: "lista-não-ordenada",
              action: SimpleMDE.toggleUnorderedList,
              className: "fa fa-list-ul",
              title: "Lista não ordenada",
            },
            {
              name: "lista-ordenada",
              action: SimpleMDE.toggleOrderedList,
              className: "fa fa-list-ol",
              title: "Lista ordenada",
            },
            {
              name: "tabela",
              className: "fa fa-table",
              title: "Inserir tabela",
              action: function(editor){
                var cm = editor.codemirror;
                cm.replaceSelection("| Coluna 1 | Coluna 2 |\n| -------- | -------- |\n| Conteudo | Conteudo |\n");
                cm.focus();
              }
            },
            "|",
            {
              name: "imagem",
              action: function customImageInsert(editor) {
                var descricao = prompt("Escreva a descrição para a imagem", "Descrição da imagem");
                if (descricao == null) return;
                var url = prompt("Escreva a URL da imagem", "https://drive.google.com/file/d/...");
                if (url == null) return;
                var googleId = getGoogleDriveFileId(url);
                if (googleId) {
                  var cm = editor.codemirror;
                  var output = `[![${descricao}](https://drive.google.com/thumbnail?id=${googleId})](https://drive.google.com/uc?id=${googleId})`;
                  cm.replaceSelection(output);
                } else {
                  var cm = editor.codemirror;
                  var output = `![${descricao}](${url})`;
                  cm.replaceSelection(output);
                }
              },
              className: "fa fa-picture-o",
              title: "Inserir imagem",
            },
            {
              name: "inserir-video",
              action: function insertYouTubeVideo(editor) {
                var videoURL = prompt("Insira o URL do vídeo do YouTube", "https://www.youtube.com/watch?v=...");
                if (!videoURL) return;
    
                // Extrair o ID do vídeo do YouTube
                var videoID = getYouTubeVideoID(videoURL);
                if (videoID) {
                  var cm = editor.codemirror;
                  var output = `<%= youtube "${videoID}" %>`;
                  cm.replaceSelection(output);
                } else {
                  alert("URL do vídeo do YouTube inválido.");
                }
              },
              className: "fa fa-youtube",
              title: "Inserir vídeo do YouTube",
            },
            "|",
            {
              name: "preview",
              action: SimpleMDE.togglePreview,
              className: "fa fa-eye no-disable",
              title: "Visualizar",
            },
            {
              name: "side-by-side",
              action: SimpleMDE.toggleSideBySide,
              className: "fa fa-columns no-disable no-mobile",
              title: "Modo lado a lado",
            },
            {
              name: "fullscreen",
              action: SimpleMDE.toggleFullScreen,
              className: "fa fa-arrows-alt no-disable no-mobile",
              title: "Tela cheia",
            },
            "|",
            {
              name: "guia",
              action: function() {
                window.open("https://simplemde.com/markdown-guide");
              },
              className: "fa fa-question-circle",
              title: "Guia Markdown",
            }
          ],
        });
        simplemde.codemirror.on("change", function() {
          localStorage.setItem("markdown-editor-content", simplemde.value());
        });
      },
    };
}
  
window.addEventListener("phx:simplemdeclear", function(event) {
    localStorage.setItem("markdown-editor-title", "");
    localStorage.setItem("markdown-editor-content", "");  
});