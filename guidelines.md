# Front-end guidelines

## General notes

### Adding sources

Sourcemaps helps you locate information on the source files via your browser developer tool, so merged files remain transparent to you.

So basically:

- when you create CSS files, make sure they are included by `assets/styles/main.scss`,
- when you create JS files, make sure they are before `assets/scripts/main.js` in the alphabetical order (as they should, using naming convention below).
- Bower dependencies JS files are compiled into a separate file `dist/scripts/vendor.js`, it's up to you to import the styles where you want to (using SCSS or not) because each package has its own way of working with CSS.

Except for external libraries, you should not need to manually declare custom styles and scripts into `index.php`.

Edit [bower.json](bower.json) and run `make install` to add front-end dependencies.

### Versioning assets (prod only)

There is a versioning helper in the `.htaccess` that redirects any `name-<hash>.min.css` to `name.min.css`, and same for `.js` files. So you can keep a single `main.min.css` and linking a different version in your HTML to force refreshing browser cache.

### Images

Images in `assets/images` are optimized with [Imagemin-CLI](https://github.com/imagemin/imagemin-cli)

## Stylesheets

### File tree

SCSS files are stored into `assets/styles/` folder, following these rules:

- `_common.scss` is for main header, main footer & other common elements across pages,
- `_global.scss` is default global styles (like `body`), and utility classes,
- `_helpers.scss` is for functions, mixins and placeholder classes,
- `_variables.scss` contains custom variables,
- then each component/page has its own file, except for single selectors or very small sets of items, which are put into `_misc.scss`,
- if you don't know where to put some code, use `_dev.scss`, but try to keep it clean as much as you can (empty is best).

You'll find notes in those files to help you keep your CSS clean.

**Note:** for large-scale applications, you may need a better CSS workflow such as [the 7-1 pattern](http://sass-guidelin.es/#the-7-1-pattern).

### Naming convention

```scss
.ComponentName-descendantName {}
.ComponentName-descendantName.modifier {}
.ComponentName-descendantName.is-stateName {}
.u-utilityClass {}

// for JS only
.js-selectorName {}
[data-attr-name] {}
```

### Defining styles

Try to:

- avoid styling over ID selectors,
- avoid using `!important` (but using Bootstrap it happens a lot more than usual),
- avoid nesting selectors, except for:

```scss
// Element states & pseudo-elements
.CustomElement {
    color: black;

    &:hover, &:focus { color: red; }
    &.active { color: green; }
    &.disabled { color: gray; }
    &.is-customState { color: blue; }
}

// Parents modifiers
.CustomElement {
    background: black; // default background

    .Wrapper.red & { background: red; }
    .Wrapper.blue & { background: blue; }
}

// Lists and consistent DOM trees
.CustomNav {
    ul { list-style: none; }

    li {
        display: inline-block;
        &.active a { text-decoration: underline; }
    }
}

// Making components: compiled CSS won't be nested
.Component {
    &-title { … } // .Component-title
    &-subtitle { … } // .Component-subtitle
}
```

- avoid duplicating behaviors, prefer using `%selector` helpers:

```scss
%Component-heading {
    // common styles
}

.Component-title {
    @extend %Component-heading;
    // specific styles
}

.Component-subtitle {
    @extend %Component-heading;
    // specific styles
}
```

### Applying styles

Try to keep your DOM straightforwards, classes must be explicit inside a component.

Try to keep the classes in that order: **component, modifiers, utilities, js**.

```html
<ul class="HomeNav snap js-snap">
    <!-- … -->
    <li class="HomeNav-item u-uppercase">
        <!-- … -->
    </li>
</ul>
```




## JavaScript

### Keeping it clean

You only need to work on `assets/scripts/`. There are example files to help you start developing your components/plugins.

Here are some little instructions in order to keep your scripts clean:

- create one file per component (jQuery plugins are components),
- add an underscore prefix to your custom components/helpers (`_example-component.js`),
- add `jquery.` prefix to your custom jQuery plugins (`jquery.example-plugin.js`),
- fragment your code into as many components as possible,
- global scope is limited to helpers and component objects only.

`assets/scripts/main.js` is the **flow**, where all the components are instantiated & their interactions described:

- use a function wrapper,
- instantiate components & plugins here:

```javascript
// bind tooltips
$('[data-toggle="tooltip"]').tooltip();

// bind datepickers
if ($.fn.datepicker) {
    $('.js-datepicker').datepicker({
        // options
    });
}
```

- avoid writing logic (algorithms),
- but put behaviors that are really small or non-specific like:

```javascript
// confirm action on click
// NOTE global, non-specific
$('[data-confirm]').on('click', function() {
    return confirm($(this).data('confirm'));
});

// focus on search input when dropdown opens (Bootstrap event)
// NOTE specific but small
var search = $('#search');
if (search.length) { // NOTE so it won't break when the element is missing
    search.on('shown.bs.dropdown', function () {
        $('#search-input').focus();
    });
}
```




## Icons
Icons are loaded with [Icomoon](https://icomoon.io/app/).

To use them, simply write `<i class="icon-favorite"></i>` (for example).

To add new icons:
- go to https://icomoon.io/app/#/projects,
- click on “Import project”,
- select `assets/fonts/selection.json` file,
- add icons,
- download your icon font,
- replace `assets/fonts/selection.json` by `selection.json`,
- open `assets/styles/_icons.scss` and replace icon selectors with those in `style.css`,
- merge `fonts/` into `assets/fonts/`.
