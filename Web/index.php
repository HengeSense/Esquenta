<?php
	include_once("includes/loginCheck.php");
?>


<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>The Ice Breaker - Sua diversão na balada</title>
	
	<meta name='language' content='pt-br'>
	<meta name='description' content='The Ice Breaker é o novo app que promete deixar sua balada ainda mais da hora! Perfeito para sua festa universitária!'>
	<meta property="og:image" content="http://theapp.pedrogoes.info/images/icon@512.png" />
	<meta name='keywords' content='usp, xupa federal, balada, jogo, pegar, catar, sexo, universidade, faculdade'>
	<meta name='robots' content='all'>
	
	<!--[if lt IE 9]>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
	
	<script src="js/jquery-1.7.1.min.js" type="text/javascript"></script>
	<script src="js/default.js" type="text/javascript"></script>
	<script src="js/analytics.js" type="text/javascript"></script>
	<script src="js/jquery.mousewheel.min.js" type="text/javascript"></script>
	<script src="js/jquery.mCustomScrollbar.min.js" type="text/javascript"></script>
	
	<link rel="stylesheet" href="css/default.css" type="text/css" media="screen and (min-device-width:490px)" />
	<link rel="stylesheet" href="css/mobile.css" type="text/css" media="handheld, (max-device-width:480px)" />
	
	<link href="favicon.ico" rel="icon" type="image/x-icon" />
</head>
<body>

	<div id="content">
	
		<div class="leftContent">
			<div class="leftContentInnerWrapper">
				<p class="title">Sua diversão na balada</p>
				
				<p class="description">Toda festa tem um evento no Facebook. O <b>Ice Breaker</b> olha todas as pessoas que estão indo para a festa e mostra o que cada uma curte (páginas, personalidades, bandas, etc...), criando um tópico em comum entre você e a pessoa!</p>
				
				<div class="voteBox">
					<div class="like">
						<img src="images/32-Heart-Shine.png" alt="Like us!" class="voteImage">
						<?php
							$result = resourceForQuery("SELECT COUNT(*) AS `number` FROM `votes`");
							$votes = mysql_result($result, 0, "number");
						?>
						<p class="voteCount"><?php echo $votes ?></p>
					</div>
					
					<div class="about">
						<p>Quer esse app? Quando conseguirmos <b>200 likes</b>, ele será lançado na App Store!</p>
					</div>
				</div>
				
				<div class="shareBox">
					<p>Compartilhe com seus amigos essa ideia!</p>
					<a href="https://www.facebook.com/theicebreakerapp" target="_blank">
						<img src="images/32-Facebook-F.png" alt="Facebook">
					</a>
					<a href="http://twitter.com/home?status=Um nova maneira de conhecer pessoas na balada! Acesse http://theapp.pedrogoes.info/ e curta essa ideia! by @pedro380085" title="Twitter!" target="_blank">
						<img src="images/32-Twitter-T.png" alt="Twitter">
					</a>
				</div>
			</div>	
		</div>

	
		<div class="rightContent">
	
			<ul class="demoStand">
				<li class="selectedDemo" id="iphone5">
					<img src="images/iphone5-Portrait.png" alt="iPhone 5">
					<img src="images/previewLogin.png" alt="Preview Login" class="preview">
				</li>
				<li id="galaxy">
					<img src="images/galaxyS3-Portrait.png" alt="Galaxy S3">
					<img src="images/previewParty.png" alt="Preview Login" class="preview">
				</li>
				<li id="iphone4">
					<img src="images/iphone-Portrait.png" alt="iPhone 4">
					<img src="images/previewPerson.png" alt="Preview Party" class="preview">
				</li>
			</ul>
			
		</div>
		
		<div style="clear: both;"></div>

	</div>
	
</body>
</html>