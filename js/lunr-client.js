let LUNR_DATA = null;
let PREVIEW_LOOKUP = null;
const BASE_URL = window.location.origin + "/";

function jsonFetch(url) {
  return new Promise(function (resolve, reject) {
    fetch(BASE_URL + url)
      .then((response) => response.json())
      .then((result) => {
        resolve(result);
      });
  });
}

// Parse search results into HTML
function parseLunrResults(results) {
  const html = [];
  for (let i = 0; i < results.length; i++) {
    const id = results[i]["ref"];
    const item = PREVIEW_LOOKUP[id];
    const title = item["t"];
    const preview = item["d"];
    const link = item["l"];
    const result =
      '<p><span class="h3"><a href="' +
      BASE_URL +
      link +
      '">' +
      title +
      "</a></span></p>" +
      preview;
    html.push(result);
  }
  if (html.length) {
    return html.join("");
  } else {
    return "<p>Your search returned no results</p>";
  }
}

function formatResults(results) {
  return `<article role="article">
		<div class="modal-header">
	        <h1>Search Results</h1>
	        <button type="button" class="btn-close" aria-label="Close" onclick="closeSearch(this);"></button>
	    </div>
	    <div class="modal-body">
		${parseLunrResults(results)}
		</div>
		</article>`;
}

function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

function closeSearch(el) {
  const elements = document.getElementsByClassName("bs-main");
  elements[1].remove();
  elements[0].classList.remove("collapse");
  return false;
}

async function search(el) {
  if (!LUNR_DATA) {
    LUNR_DATA = await jsonFetch("js/search_index.json");
  }

  if (!PREVIEW_LOOKUP) {
    PREVIEW_LOOKUP = await jsonFetch("js/preview.json");
  }

  const query = document.getElementById("search-input").value;
  const idx = lunr.Index.load(LUNR_DATA);
  // Write results to page
  const results = idx.search(query);
  const elements = document.getElementsByClassName("bs-main");

  if (elements.length < 2) {
    const resultHtml = `<main role="main" class="container bs-main">
	    	${formatResults(results)}</main>`;

    elements[0].insertAdjacentHTML("afterend", resultHtml);
  } else {
    elements[1].innerHTML = formatResults(results);
  }

  elements[0].classList.add("collapse");
  window.scrollTo(0, 0);
  return false;
}
