/** Index page renderer.
 */
define(["../helper/pagination",
        "../helper/segment-viewer",
        "../helper/util"],
function(Pagination, Viewer, util) {

  function render(data, params) {
    var pagination = new Pagination(data.imageURLs.length, params);
    document.body.appendChild(pagination.render());
    for (var i = pagination.begin(); i < pagination.end(); ++i) {
      var viewer = new Viewer(data.imageURLs[i], data.annotationURLs[i], {
                                width: (params.width || 100),
                                height: (params.height || 100),
                                colormap: data.colormap,
                                labels: data.labels,
                                excludedLegends: [0],
                                overlay: i.toString()
                              }),
          anchor = document.createElement("a");
      anchor.appendChild(viewer.container);
      anchor.href = util.makeQueryParams({ view: "edit", id: i+1 });
      document.body.appendChild(anchor);
    }
  }

  return render;
});
