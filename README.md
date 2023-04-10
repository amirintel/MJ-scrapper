# MJ_scrapper
Un scrapper simple en shell permettant de récupérer les prompts d'un user ou d'une recherche ciblée.

Contexte

Après mon Thread portant sur le site web MIDJOURNEY et son API, j'ai promis de développer un scrapper permettant de récupérer tous les prompts d'un user.
https://twitter.com/Amir_Intel/status/1644770718192750592

Voici donc la première itération, en script shell.
Elle nécessite que vous connaissiez déjà le USER ID et que vous possédez des cookies valides d'un compte Midjourney.

Comment l’utiliser ?

1/ Vous devez tout d’abord rentrer le userID (ou UUID) ciblé, par un simple copié-collé, vous le trouverez dans un URL du type : 
https://www.midjourney.com/app/users/17b8ac2a-1925-41c7-ab64-f44d6ecf99ac
--> Ici "17b8ac2a-1925-41c7-ab64-f44d6ecf99ac" est l'userID
 
2/ L'outil vous demandera ensuite votre cookie Midjourney.
Vous devez avoir un compte Midjourney valide pour pouvoir copier-coller votre cookie, la première chose à faire est de se rendre à l’URL suivante : 
https://www.midjourney.com/app/


 
Ensuite, ouvrez l’outil du développeur sur Firefox (Ctrl + Maj + I) ou Chrome (F12) et récupérez votre cookie de connexion comme suit
![2023-04-10 20_28_38-Outils de développement - Your Midjourney Profile - https___www midjourney com_a](https://user-images.githubusercontent.com/130395160/231003700-660de175-42c3-4c3a-b03e-4fd6435b3bc6.png)


Une fois que vous aurez copié-collé votre cookie une première fois dans l'outil, il sera stocké dans un fichier cookie.txt et vous n'aurez normalement plus besoin de le rentrer à nouveau.

Bon scrapping !
