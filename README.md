# Globbox

Globbox is meant as a **SCSS toolbox** instead of a standalone CSS framework.
It serves **modular** mixins and placeholder classes to extend your own components, preserving your namespace and your DOM.

## Installation

Make sure [Node.js](https://nodejs.org/) is installed and that you are able to install packages in global.

Clone this repo, then run:

```shell
make install # removes the documentation
make install docs=true # OR backups the documentation

make all # build
make watch # OR build & watch for changes on localhost:3000
make watch host=<host> port=<port> # OR build & watch for changes on <host>:<port>
make watch sync=false # OR build & watch for changes, without Browser-sync
```

This documentation serves as an example.

**Note:** think about adding `dist/` into `.gitignore` after installing.
Globbox versions `dist/` only to make its documentation available through Github pages.

## Compilation

Globbox comes with a default architecture, compiling on Makefile.
However Globbox files could be extracted and compiled separately, with your own method, following these instructions:

- Import `assets/styles/globbox/globbox.scss` in your main SCSS file before compiling.
Comment/uncomment de modules you want.
- Load or import the `assets/scripts/_globox.js` file anywhere.
It's best to concat your scripts in a single file.

Assets come self documented, you'll find dependencies notes and comments on each file.


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
$nested-grid: (sm: 2, md: 3, lg: 4);
.Parent {
    @extend %grid;

    &-row {
        @include row($nested-grid);
    }

    /* … */
}

.Child {
    @include column((sm: 2), $nested-grid);
    padding: 0;

    &-row {
        @include row((xs: 2));
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
