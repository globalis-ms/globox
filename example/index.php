<?php
// Generate random words
function words($min, $max = false) {
    static $words = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a nisl felis. Sed facilisis diam nec convallis blandit. In hac habitasse platea dictumst. Nullam consectetur consectetur tortor, sed posuere erat bibendum nec. Pellentesque felis justo, aliquam non molestie eu, luctus et magna. Curabitur sapien odio, luctus sit amet sem id, dignissim scelerisque nisl. Nam at arcu tellus. Maecenas condimentum ligula a metus molestie ullamcorper. Sed varius in eros ac tristique. Quisque ac velit lectus. Aenean rutrum sollicitudin malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In a dictum risus. Cras sed odio ut dolor commodo efficitur. Proin faucibus orci maximus turpis tincidunt imperdiet.';
    if (is_string($words)) $words = explode(' ', preg_replace('/[^\w\s]/', '', strtolower($words)));
    shuffle($words);
    if (!$max) $max = $min;
    return ucfirst(join(' ', array_slice($words, 0, mt_rand($min, $max))));
}
?>
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Globox</title>
	<meta name="robots" content="noindex, nofollow">
	<link href="dist/styles/main.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Material+Icons" rel="stylesheet">
</head>
<body>
	<div class="Grid">
		<section class="Grid-row">
			<?php foreach (range(1,5) as $i): ?>
			<article class="Grid-cell<?= $i == 2 ? ' is-full' : null ?>">
				<?= words(15,50) ?>
			</article>
			<?php endforeach ?>
		</section>
	</div>

	<script src="dist/scripts/main.js"></script>
</body>
</html>
