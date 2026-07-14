{{flutter_js}}
{{flutter_build_config}}

(function () {
  var statusEl = document.getElementById("flutter-loading-status");
  var loadingEl = document.getElementById("flutter-loading");
  var hostEl = document.getElementById("flutter_host");

  function setStatus(text) {
    if (statusEl) statusEl.textContent = text;
  }

  _flutter.loader.load({
    config: {
      hostElement: hostEl,
    },
    onEntrypointLoaded: async function (engineInitializer) {
      setStatus("Initializing engine…");
      var appRunner = await engineInitializer.initializeEngine();
      setStatus("Almost there…");
      await appRunner.runApp();
      if (loadingEl) {
        loadingEl.classList.add("done");
        setTimeout(function () {
          if (loadingEl && loadingEl.parentNode) {
            loadingEl.parentNode.removeChild(loadingEl);
          }
        }, 400);
      }
    },
  });
})();
