if ("paintWorklet" in CSS) {
  CSS.paintWorklet.addModule(
    "https://www.unpkg.com/css-houdini-squircle@0.3.0/squircle.min.js"
  );
}

console.log(
  "jules@ishot userChrome.js has been injected, now why isn't someone injecting their userChrome into her?"
);

let tabIcons = document.getElementsByClassName("tab-close-button");
console.log(tabIcons);
Array.from(tabIcons).forEach((item) => {
  item.classList.add("squircle-mask");
});
