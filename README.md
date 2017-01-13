[![MIT license](https://img.shields.io/badge/license-MIT-yellow.svg?style=flat-square)](https://github.com/globalis-ms/globbox/blob/master/LICENSE)

Globbox is meant as a **SCSS toolbox** instead of a standalone CSS framework.
It serves **modular** mixins and placeholder classes to extend your own components, preserving your namespace and your DOM.
Note that it first has been made for internal purposes at [GLOBALIS media systems](https://www.globalis-ms.com/).

Thanks,  
[Nicolas Torres](mailto:nicolas.torres@globalis-ms.com) and [Sylvain Dubus](mailto:sylvain.dubus@globalis-ms.com)


# Starter kit

Globbox comes as a front-end starter kit with a small footprint, with build tools and a folders structure.

## Installation and build

Make sure [Node.js](https://nodejs.org/) is installed and that you are able to install packages globally.

Clone this repo, then run:

```shell
# Installation
make -s install # init project: removes the documentation

# Installation options
make -s install docs=true # backups the documentation
make -s install global=true # skip NPM dependencies
make -s install docs=true global=true # backups the documentation AND skip NPM dependencies

# Development tools
make -s all # build
make -s watch # build & watch for changes on localhost:3000
make -s watch host=<host> port=<port> # OR build & watch for changes on <host>:<port>
make -s watch sync=false # OR build & watch for changes, without Browser-sync
```

**Notes:**
- the -s option stands for silent mode.
- think about adding `dist/` into `.gitignore` after installing. Globbox versions `dist/` only to make its documentation available through Github pages.
- skipping NPM dependencies suggests that you have the packages installed globally.

This documentation also serves as an demo package.

## Make options

These options can be either modified directly in the Makefile configuration part or used as arguments :
```shell
make -s <command> <option>=<value>
```

option | default value | description
--- | --- | --- | --- | ---
sync | true | Uses BrowserSync while watching
host | http://localhost | BrowserSync's URL
port | 3000 | BrowserSync's port
docs | false | Keeps documentation on a separate folder after install
global | false | Skip npm dependencies on install


## Compilation

Globbox comes with its starter architecture, compiling on Makefile.
However the Globbox toolbox can be extracted and compiled separately, with your own method, following these instructions:

- Import `globbox.scss` and its dependencies in your main SCSS file before compiling.
Comment/uncomment de modules you want.
- Load or import the `_globbox.js` file anywhere.
It's best to concat your scripts in a single file.

Assets come self documented, you'll find dependencies notes and comments on each file.


# Components

## Breakpoints

screens | devices | notation | pixels | default media query
--- | --- | --- | --- | ---
extra&nbsp;small | small phones | **xs** | 0 | *no media queries*
small | > 5" phones | **sm** | 420 | `@media (min-width: 420px) { … }`
medium | landscape phones, tablets | **md** | 768 | `@media (min-width: 768px) { … }`
large | landscape tablets, common desktop | **lg** | 1024 | `@media (min-width: 1024px) { … }`
extra&nbsp;large | huge desktop | **xl** | 1440 | `@media (min-width: 1440px) { … }`

```css
/* @media (min-width: 420px) { … } */
@include breakpoint-up(sm) { … }

/* @media (max-width: 1439px) { … } */
@include breakpoint-down(lg) { … }

/* @media (min-width: 420px) and (max-width: 1439px) { … } */
@include breakpoint-between(sm, lg) { … }

/* @media (min-width: 768px) and (max-width: 1023px) { … } */
@include breakpoint-only(md) { … }
```



## Grid

The grid isn't base on 12 columns or any other unit.
You choose the number of columns, then 1 cell sizes 1 column by default.

This structure allows a straightforward declaration of the grid sizes with a custom number of columns, and also removes the usual calculations the 1/12 unit imposes.

It's based on **flexbox** and the `calc()` function.

### Default grid

<div class="Simple">
    <div class="Simple-row">
        <div class="Simple-cell"></div>
        <div class="Simple-cell"></div>
        <div class="Simple-cell"></div>
        <div class="Simple-cell"></div>
    </div>
</div>

```html
<div class="Component">
    <div class="Component-row">
        <div class="Component-cell"> … </div>
        <div class="Component-cell modifiers"> … </div>
        <div class="Component-cell"> … </div>
        <div class="Component-cell"> … </div>
    </div>
</div>
```

```css
.Component {
    @extend %grid;

    &-row {
        /* 1 column on XS, 2 on SM, 3 on MD… */
        @include row((sm: 2, md: 3, lg: 4));
    }

    &-cell {
        margin-bottom: $gutter;
    }
}
```

### Cell style, size and offset

Gutter are made with margins, since widths are calculated with `calc()` helper.
This allows setting padding, borders and background colors in the cell element.

<div class="Extended">
    <div class="Extended-row">
        <div class="Extended-cell">placeholder cell content</div>
        <div class="Extended-cell modifiers">placeholder cell content</div>
        <div class="Extended-cell">placeholder cell content</div>
        <div class="Extended-cell">placeholder cell content</div>
    </div>
</div>

```css
.Component {
    @extend %grid;

    &-row {
        @include row((sm: 2, md: 3, lg: 4));
    }

    &-cell {
        margin-bottom: $gutter;
        padding: 20px;
		border: 4px solid #212121;
        background: rgba(yellow, .2);

        &.modifiers {
            /* takes 2 columns on SM, 1 on MD, 2 on LG */
            @include column((sm: 2, md: 1, lg: 2));

            /* offsets by 1 column on MD and LG */
			@include offset((md: 1, xl: 0));
        }
    }
}
```

### Nested grid

Supported but not optimal yet. Could be needing further thoughts.

<div class="Parent">
    <div class="Parent-row">
        <div class="Parent-cell"></div>
        <div class="Parent-cell Child">
            <div class="Child-row">
                <div class="Child-cell"></div>
                <div class="Child-cell"></div>
            </div>
        </div>
        <div class="Parent-cell"></div>
    </div>
</div>

```html
<div class="Parent">
    <div class="Parent-row">
        <div class="Parent-cell"></div>
        <div class="Parent-cell Child">
            <div class="Child-row">
                <div class="Child-cell"></div>
                <div class="Child-cell"></div>
            </div>
        </div>
        <div class="Parent-cell"></div>
    </div>
</div>
```

```css
.Parent {
    @extend %grid;

    &-row {
        @include row((sm: 2, md: 3, lg: 4););
    }

    &-cell {
        margin-bottom: $gutter;
    }
}

.Child {
    @include column((sm: 2)); /* uses previous `row()` declaration for sizing */
    padding: 0;

    &-row {
        @include row((xs: 2));
    }

    &-cell {
        margin-bottom: $gutter;
    }
}
```

Solving size conflicts with non-linear declarations:

```css
$parent-grid: (sm: 2, md: 3, lg: 4);
.Parent {
    @extend %grid;

    &-row {
        @include row($parent-grid);
    }

    /* … */
}

$child-grid: (xs: 2);
.Child {
    @include column((sm: 2), $parent-grid);
    padding: 0;

    &-row {
        @include row($child-grid);
    }

    /* … */
}
```



## Fonts and icons

### Icons
Icons come from [Icomoon](https://icomoon.io/app), which allow you to import and export your set as JSON, that is best to version into your repository. It's loaded by default with no icons.

### Fonts declaration

A font helper lets you simply declare fonts as a list of arguments in `_variables.scss`.


```
$fonts: (
    ("icomoon", "icomoon", normal, normal),
) !default;
```

To add a font, simply duplicate the line and change the arguments, following this order:

1. **Font name**: the one you call in `font-family` property.
2. **File name** without the extension: if you have font variations, keep the same `font name` argument between files declaration.
3. **Font weight**: the `font-weight` value defining the current font variation.
4. **Font style**: the `font-style` value defining the current font variation.

### Use rems

A function helps you convert pixels into `rem`:

```css
.title {
    font-size: rem(40px);
}
```
