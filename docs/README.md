# Globbox

## General



## Breakpoints

screens | notation | pixels | default media query
--- | --- | --- | ---
extra small (small phones) | **xs** | 0 | *no media queries*
small (> 5" phones) | **sm** | 420 | `@media (min-width: 420px) { … }`
medium (landscape phones, tablets) | **md** | 768 | `@media (min-width: 768px) { … }`
large (common desktop) | **lg** | 1024 | `@media (min-width: 1024px) { … }`
extra large (huge desktop) | **xl** | 1440 | `@media (min-width: 1440px) { … }`

```css
/* @media (min-width: 420px) { … } */
@include breakpoint-up(sm) { … }

/* @media (max-width: 1023px) { … } */
@include breakpoint-down(lg) { … }

/* @media (min-width: 420px) and (max-width: 1439px) { … } */
@include breakpoint-between(sm, lg) { … }

/* @media (min-width: 768px) and (max-width: 1023px) { … } */
@include breakpoint-only(md) { … }
```

## Grid

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

### Styling cells

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
