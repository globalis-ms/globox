[![MIT license](https://img.shields.io/badge/license-MIT-yellow.svg?style=flat-square)](https://github.com/globalis-ms/globbox/blob/master/LICENSE)

Globbox is meant as a **SCSS toolbox** instead of a standalone CSS framework.
It serves **modular** mixins and placeholder classes to extend your own components, preserving your namespace and your DOM.
Note that it first has been made for internal purposes at [GLOBALIS media systems](https://www.globalis-ms.com/).

Thanks,  
[Nicolas Torres](mailto:nicolas.torres@globalis-ms.com) and [Sylvain Dubus](mailto:sylvain.dubus@globalis-ms.com)


# Starter kit

Globbox comes as a front-end starter kit with a small footprint, with build tools and a folders structure.
You will also find some [front-end guidelines](guidelines.md) to keep the project clean.

## Installation and build

Make sure [Node.js](https://nodejs.org/) is installed and that you are able to install packages globally.

Clone this repo, then run:

```shell
git clone git@github.com:globalis-ms/globbox.git <project_name>
cd <project_name>

# Installation
make -s install # install NPM modules and bower dependencies
make -s build # build assets
make -s all # for both installation and build

# Development tools
make -s watch # build & watch for changes on localhost:3000
make -s watch host=<host> port=<port> # OR build & watch for changes on <host>:<port>
make -s watch sync=false # OR build & watch for changes, without Browser-sync
```

**Notes:**
- the -s option stands for silent mode.
- skipping NPM dependencies suggests that you have the packages installed globally.

This documentation can be found in the docs/ folder.

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
global | false | Skip local node modules installation


## Compilation

Globbox comes with its starter architecture, compiling on Makefile.
However the Globbox toolbox can be extracted and compiled separately, with your own method, following these instructions:

- Import `globbox.scss` and its dependencies in your main SCSS file before compiling.
Comment/uncomment de modules you want.
- Load or import the `_globbox.js` file anywhere.
It's best to concat your scripts in a single file.

Assets come self documented, you'll find dependencies notes and comments on each file.



---

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

<div class="Sample1">
    <div class="Sample1-row">
        <div class="Sample1-cell Cell">1</div>
        <div class="Sample1-cell Cell">2</div>
        <div class="Sample1-cell Cell">3</div>
        <div class="Sample1-cell Cell">4</div>
    </div>
</div>

```html
<div class="Sample1">
    <div class="Sample1-row">
        <div class="Sample1-cell Cell">1</div>
        <div class="Sample1-cell Cell">2</div>
        <div class="Sample1-cell Cell">3</div>
        <div class="Sample1-cell Cell">4</div>
    </div>
</div>
```

```css
.Cell {
    text-align: center;
    font-size: 1rem;
    padding: $unit/2 0;
    font-family: sans;
    color: #fff;
}

.Sample1 {
    @include set-gutter($unit);
    background: rgba(#1375a6, .2);

    &-row {
        @include row((sm: 2, md: 3, lg: 4));
    }

    &-cell {
        background: rgba(#1375a6, .4);
    }
}
```

### Custom gutter width

```css
.Sample1 {
    @include set-gutter(2rem);
}
```

Setting a custom gutter will affect following grids.
It's better setting it on each `set-gutter()` declaration.
Default value is `$unit`.

### Cell style, size and offset

Gutter are made with margins, since widths are calculated with `calc()` helper.
This allows setting padding, borders and background colors in the cell element.

<div class="Sample2">
    <div class="Sample2-row">
        <div class="Sample2-cell Cell">placeholder cell content</div>
        <div class="Sample2-cell Cell modifiers">placeholder cell content</div>
        <div class="Sample2-cell Cell">placeholder cell content</div>
        <div class="Sample2-cell Cell">placeholder cell content</div>
    </div>
</div>

```html
<div class="Sample2">
    <div class="Sample2-row">
        <div class="Sample2-cell Cell">placeholder cell content</div>
        <div class="Sample2-cell Cell modifiers">placeholder cell content</div>
        <div class="Sample2-cell Cell">placeholder cell content</div>
        <div class="Sample2-cell Cell">placeholder cell content</div>
    </div>
</div>
```

```css
.Cell {
    text-align: center;
    font-size: 1rem;
    padding: $unit/2 0;
    color: #fff;
}

.Sample2 {
    @include set-gutter($unit);
    background: rgba(#1375a6, .2);

    &-row {
        @include row((sm: 2, md: 3, lg: 4));
    }

    &-cell {
        border: 4px solid #1375a6;
        background: rgba(#1375a6, .4);

        &.modifiers {
            @include column((sm: 2, md: 1, lg: 2));
            @include offset((md: 1, xl: 0));
        }
    }
}
```

### Nested grid

Supported but not optimal yet. Could be needing further thoughts.

<div class="Sample3">
    <div class="Sample3-row">
        <div class="Sample3-cell Cell">1</div>
        <div class="Sample3-cell Sample3Child">
            <div class="Sample3Child-row">
                <div class="Sample3Child-cell Cell">2.1</div>
                <div class="Sample3Child-cell">
                    <div class="Sample3Grandchild-row">
                        <div class="Sample3Grandchild-cell Cell">2.2.1</div>
                        <div class="Sample3Grandchild-cell Cell">2.2.2</div>
                        <div class="Sample3Grandchild-cell Cell">2.2.3</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Sample3-cell Cell isLarge"><span class="Cell-content">3</span></div>
    </div>
</div>

```html
<div class="Sample3">
    <div class="Sample3-row">
        <div class="Sample3-cell Cell">1</div>
        <div class="Sample3-cell Sample3Child">
            <div class="Sample3Child-row">
                <div class="Sample3Child-cell Cell">2.1</div>
                <div class="Sample3Child-cell">
                    <div class="Sample3Grandchild-row">
                        <div class="Sample3Grandchild-cell Cell">2.2.1</div>
                        <div class="Sample3Grandchild-cell Cell">2.2.2</div>
                        <div class="Sample3Grandchild-cell Cell">2.2.3</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Sample3-cell Cell isLarge"><span class="Cell-content">3</span></div>
    </div>
</div>
```

```css
.Cell {
    text-align: center;
    font-size: 1rem;
    padding: $unit/2 0;
    color: #fff;
}

.Sample3 {
    @include set-gutter($unit);

    &-row {
        @include row((sm: 2, md: 3, lg: 4));
        background: rgba(#1375a6, .2);
    }

    &-cell {
        background: rgba(#1375a6, .4);
        &.isLarge {
            @include column((sm: 2, md: 3, lg: 1));
        }
    }

}

.Sample3Child {
    @include column((md: 2));

    &-row {
        @include row((md: 2));
    }

    &-cell {
        background: rgba(#1375a6, .6);
    }
}

.Sample3Grandchild {
    @include set-gutter($unit/2);
    
    &-row {
        @include row((md: 3));
    }

    &-cell {
        background: #1375a6;
        font-size: 0.75rem;
    }
}
```

Solving size conflicts with non-linear declarations:

```css
$parent-grid: (sm: 2, md: 3, lg: 4);
.Parent {
    @include set-gutter($unit);

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
