// A lot of this is taken form https://github.com/lsjroberts/gelatin-design/blob/master/build.js

var metalsmith  = require("metalsmith")
    , markdown  = require("metalsmith-markdown")
    , templates = require("metalsmith-templates")
    , collections  = require("metalsmith-collections")
    , permalinks = require("metalsmith-permalinks")
    , branch = require("metalsmith-branch")
    , ignore = require("metalsmith-ignore")
;

var baseUrl = "/mokacoding-metalsmith/";
// TODO: find something better
// turn on for development
baseUrl = "/";

metalsmith(__dirname)
  .source("src")
  .destination("..")
  .clean(true).except([
    ".git",
    "CNAME",
    "metallo",
    "node_modules",
    ".gitignore",
    "Makefile",
    "npm-shrinkwrap.json",
    "package.json",
    "README.md",
    "TODO.md"
  ])

  .use(ignore("templates/*"))
  .use(ignore("assets/*"))

  .use(function(files, metalsmith, done) {
    metalsmith.metadata().baseUrl = baseUrl;
    done();
  })

  // automatically set some values for the posts
  // lazy devolepers => smart developers
  .use(branch("posts/*.md")
    .use(function (files, metalsmith, done) {
      for (var key in files) {
        var post = files[key];
        var name = key.split("/").pop();

        var date = post.date;
        if (!date) {
          date = name.slice(0,10);
          post.date = new Date(date);
        }

        // set post slug based on file name
        var slug = name.slice(11, -3);
        post.slug = slug;

        // set tags to empty array if tags are missing form post
        // (this avoids crashes in the templete)
        // TODO: or should it be responsibility of the template to check that tags exist?
        var tags = post.tags;
        if (!tags) { post.tags = []; }

        // If not specified, enable Disqus by default
        var comments = post.comments;
        if (comments == null) {
          post.comments = true;
        }
      }
      done();
    })
  )

  // important: collections must be set before templates
  // or the templates won't have the variables and crash
  .use(collections({
    posts: {
      pattern: "posts/*",
      sortBy: "date",
      reverse: true
    }
  }))

  .use(markdown({
    highlight: function (code) {
      return require('highlight.js').highlightAuto(code).value;
    },
    langPrefix: 'hljs '
  }))

  .use(branch("posts/*.html")
    .use(permalinks({
        pattern: 'blog/:slug'
    }))
    .use(function (files, metalsmith, done) {
      for (var file in files) {
        files[file].template = 'post.jade';
      }
      done();
    })
    .use(function (files, metalsmith, done) {
      for (var key in files) {
        post = files[key];

        var day = post.date.getDate();
        if (day < 10) { day = "0" + day; }

        var month = post.date.getMonth() + 1;
        if (month < 10) { month = "0" + month; }

        var path = post.date.getFullYear() + "/" + month + "/" + day + "/" + post.slug + ".html";

        var retrocompatible_post = {};
        for (var _key in post) {
          retrocompatible_post[_key] = post[_key];
        }

        files[path] = retrocompatible_post;
      }
      done();
    })
  )

  // for the moment the blog has a post per page, no point in paginating it when collections already
  // provider next and previous
  // .use(paginator)
  .use(tagList)

  // temp fix for metalsmith-template corrupting images
  // see https://github.com/segmentio/metalsmith/issues/60 and https://github.com/segmentio/metalsmith-templates/issues/17
  .use(branch(filterImages)
    .use(templates({
      engine: "jade",
      directory: "src/templates"
    }))
  )

  .build(function(err) {
    if (err) {
      throw err;
    } else {
      console.log("✔ done");
    }
  }
);

function filterImages(filename, properties, index) {
  var extension = filename.split('.').pop().toLowerCase();
  var imageExtensions = [ "jpg", "jpeg", "png" ];
  var notAnImage = imageExtensions.indexOf(extension) == -1;
  return notAnImage;
}


function paginator(files, metalsmith, done) {

  /*
   * mokagio's version
   *
  var posts = metalsmith.data.posts;

  var pages = [];
  var postsPerPage = 2;

  var numberOfPages = Math.ceil(posts.length / postsPerPage);
  for (var i = 0; i < numberOfPages; i++) {
    pages.push( posts.slice((postsPerPage * i), ((postsPerPage * i) + postsPerPage)) );
  }

  console.log(pages);
  console.log("Built an array of " + pages.length + " pages, with " + postsPerPage + " items per page. Last page has " + pages[numberOfPages - 1].length + " items");

  var index = files['index.md'];
  index.posts = pages[0];
  */

  // lsjroberts version
  var index = files['index.html'],
      original_posts = metalsmith.data.posts,
      perPage = 1;

  // hack for rendering of multiple templates.
  //
  // if we push the original post object in the pagination array, when it comes to render the pagination view jade is gonna render
  // first the pagination, which extends the base template, then when it comes to the post it's gonna render the post as it's own
  // page extending the base template as well, this means that we're gonna end up with a weird page inside the page.
  //
  // i'm sure that to avoid it there must be some option to pass to the jade compiler, but i haven't find it yet.
  //
  // what we do here is manually copy (by value) the posts array in order to be able to reset the template of the object that will
  // go in the pagination array, without changing the original one.
  posts = [];
  for (var i = 0; i < original_posts.length; i++) {
    original_post = original_posts[i];
    post = {};
    for (var key in original_post) {
      if (key != 'template') {
        post[key] = original_post[key];
      }
    }
    posts.push(post);
  }

  index.posts = posts.slice(0,perPage);
  index.currentPage = 1;
  index.numPages = Math.ceil(posts.length / perPage);
  index.pagination = [];

  for (var i = 1; i <= index.numPages; i++) {
      index.pagination.push({
          num: i,
          url: (1 == i) ? '' : 'index/' + i
      });

      if (i > 1) {
          files['index/' + i + '/index.html'] = {
              template: 'index.jade',
              mode: '0644',
              contents: '',
              title: 'Page ' + i + ' of ' + index.numPages,
              posts: posts.slice((i-1) * perPage, ((i-1) * perPage) + perPage),
              currentPage: i,
              numPages: index.numPages,
              pagination: index.pagination,
          };
      }
  }

  done();
}

function tagList(files, metalsmith, done) {
  var tags = {};

  for (var post in metalsmith.data.posts) {
      for (var t in metalsmith.data.posts[post].tags) {
          tag = metalsmith.data.posts[post].tags[t];
          tag = tag.replace(/ /g, "-");
          if (! tags[tag]) {
              tags[tag] = [];
          }

          tags[tag].push(metalsmith.data.posts[post]);
      }
  }

  for (var tag in tags) {
    path = 'tag/' + tag + '/index.html';
    files[path] = {
      template: 'tag-index.jade',
      mode: '0644',
      contents: '',
      title: "Posts tagged '" + tag + "'",
      posts: tags[tag],
      tag: tag,
      path: path,
    };
  }

  done();
}
