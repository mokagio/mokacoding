// A lot of this is taken form https://github.com/lsjroberts/gelatin-design/blob/master/build.js

var metalsmith  = require("metalsmith")
    , markdown  = require("metalsmith-markdown")
    , highlight = require("highlight.js")
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
    "package-lock.json",
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
        }
        post.date = new Date(date);

        if (post.updated_at !== undefined) {
          post.updated_at = new Date(post.updated_at)
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

  .use(tagList)

  .use(markdown({
    highlight: function (code, lang) {
      if (lang == undefined || highlight.getLanguage(lang) == undefined) {
        return highlight.highlightAuto(code).value;
      } else {
        return highlight.highlight(lang, code).value;
      }
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

        let year = post.date.getFullYear();
        var path = year + "/" + month + "/" + day + "/" + post.slug + ".html";

        if (year > 2013) {
          continue;
        }

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

  // temp fix for metalsmith-template corrupting images
  // see https://github.com/segmentio/metalsmith/issues/60 and https://github.com/segmentio/metalsmith-templates/issues/17
  .use(branch(filterImages)
    .use(templates({
      engine: "jade",
      directory: "src/templates"
    }))
  )

  .use(function (files, metalsmith, done) {
    files['feed.xml'] = files['feed.html'];
    delete files['feed.html'];
    done();
  })

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

function tagList(files, metalsmith, done) {
  var rawTags = {};

  for (var post in metalsmith.data.posts) {
      for (var t in metalsmith.data.posts[post].tags) {
          tag = metalsmith.data.posts[post].tags[t];
          tag = tag.replace(/ /g, "-");
          tag = tag.toLowerCase();
          if (! rawTags[tag]) {
              rawTags[tag] = [];
          }

          rawTags[tag].push(metalsmith.data.posts[post]);
      }
  }

  var tags = []

  for (var tag in rawTags) {
    tags.push({ name: tag, posts: rawTags[tag] })
  }

  const sortedTags = tags.sort((a, b) => a.posts.length < b.posts.length ? 1 : -1);
  metalsmith.metadata().tags = sortedTags//.map((t) => t.name);

  for (var tag of sortedTags) {
    path = 'tag/' + tag.name + '/index.html';
    files[path] = {
      template: 'tag-index.jade',
      mode: '0644',
      contents: '',
      title: "Posts tagged '" + tag.name + "'",
      posts: tag.posts,
      tag: tag.name,
      path: path,
    };
  }

  done();
}
