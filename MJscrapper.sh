#!/bin/bash
 
cookie_file="cookie.txt"
RED="\033[0;31m"
NC="\033[0m"

echo -e "Entrez l'${RED}UUID${NC} de l'user puis appuyez sur Entree "
read my_uuid
echo -e "\n \nVoici l'UUID : ${my_uuid}! \n \n"
echo -e "________________________________ \nVerification de la présence du fichier ${RED}cookie.txt"
if [ -f "$cookie_file" ] && [ -s "$cookie_file" ]; then
    echo "Le fichier cookie.txt existe et n'est pas vide,on continue!"
    my_cookie=$(cat "$cookie_file")
else
echo -e "________________________________ \n"
echo -e "\nCookie.txt vide ou absent, veuillez copier-coller ici le cookie Midjourney puis appuyez sur Entree"
read my_cookie
echo "$my_cookie" > "$cookie_file"
fi
echo -e "\n _____________________________________\n"
echo -e "${RED}Interrogation de l'API\n"
seq 0 50 | xargs -I {} curl "https://www.midjourney.com/api/app/recent-jobs/?amount=50&page={}&dedupe=true&jobStatus=completed&minRankingScore=0&orderBy=new&prompt=undefined&refreshApi=0&searchType=advanced&service=null&userId={$my_uuid}&user_id_ranked_score=0,4,5&_ql=todo&_qurl=https://www.midjourney.com/app/users/{$my_uuid}/" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" -H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "Alt-Used: www.midjourney.com" -H "Connection: keep-alive" -H "Cookie: {$my_cookie}" -H "Upgrade-Insecure-Requests: 1" -H "Sec-Fetch-Dest: document" -H "Sec-Fetch-Mode: navigate" -H "Sec-Fetch-Site: none" -H "Sec-Fetch-User: ?1" -H "TE: trailers" --compressed >> infos$my_uuid.txt
echo -e "Recuperation des dates des prompts \n"
cat infos$my_uuid.txt | grep -oP '(?<="prompt":")[^"]*' > prompts$my_uuid.txt
echo -e "\n _____________________________________\n -->Sauvegarde des prompts de l'User dans un fichier prompt$my_uuid \n \n \n"
echo -e "Recuperation des dates de generation \n"
cat infos$my_uuid.txt | grep -oP '(?<="enqueue_time":")[^.]*' > dates$my_uuid.txt
echo -e "\n _____________________________________\n -->Sauvegarde des dates de generation dans un fichier date$my_uuid "
echo -e "\n _____________________________________\n"
echo -e "Fusion des fichiers de prompts et de dates en un fichier CSV \n"
paste -d ';' prompts$my_uuid.txt dates$my_uuid.txt > resultats$my_uuid.csv
echo -e "\n _____________________________________\n -->${RED}Sauvegarde de la compilation prompts+dates dans un fichier resultats$my_uuid.csv "