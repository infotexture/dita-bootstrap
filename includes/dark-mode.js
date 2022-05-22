(() => {
  'use strict';

  const root = document.documentElement;
  const activeTheme = localStorage.getItem('theme');

  const checkSystemTheme = function () {
    // if OS dark mode is set, and there's no stored theme, set the theme to dark (but don't store it)
    if (window.matchMedia('(prefers-color-scheme: dark)').matches && !activeTheme) {
      document.documentElement.setAttribute('data-theme', 'dark');
    } else {
      // otherwise, set the theme to the default (light)
      document.documentElement.removeAttribute('data-theme');
    }
  };

  const setTheme = function (theme) {
    document.querySelectorAll('[data-theme-value]').forEach(element => {
      element.classList.remove('active');
    });

    const btnToActive = document.querySelector(`[data-theme-value="${theme}"]`);
    btnToActive.classList.add('active');
  };

  document.querySelectorAll('[data-theme-value]').forEach(toggle => {
    toggle.addEventListener('click', () => {
      const theme = toggle.getAttribute('data-theme-value');
      setTheme(theme);

      if (theme === 'auto') {
        root.removeAttribute('data-theme');
        localStorage.removeItem('theme');
        checkSystemTheme();
      } else {
        root.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
      }
    });
  });

  if (activeTheme) {
    root.setAttribute('data-theme', activeTheme);
    setTheme(activeTheme);
  } else {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      checkSystemTheme();
    });
    checkSystemTheme();
  }
})();
