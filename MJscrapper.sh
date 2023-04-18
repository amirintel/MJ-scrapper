#!/bin/bash
 
cookie_file="cookie.txt"
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"
BLUE="\033[0;34m"
user_id=""
date=$(date +"%d:%m:%Y")

echo -e "________________________________ \n\nVerification de la présence du fichier ${BLUE}cookie.txt${NC}"
if [ -f "$cookie_file" ] && [ -s "$cookie_file" ]; then
    echo -e "${GREEN}Le fichier cookie.txt existe et n'est pas vide,on continue!${NC}"
    my_cookie=$(cat "$cookie_file")
else
echo -e "________________________________ \n"
echo -e "\nCookie.txt vide ou absent, veuillez copier-coller ici le cookie Midjourney puis appuyez sur Entree"
read my_cookie
echo "$my_cookie" > "$cookie_file"
fi
echo -e "\n________________________________ \n"


cookietest=$(curl -I "https://www.midjourney.com/api/app/users/info/" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" -H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "Alt-Used: www.midjourney.com" -H "Connection: keep-alive" -H "Cookie: {$my_cookie}" -H "Upgrade-Insecure-Requests: 1" -H "Sec-Fetch-Dest: document" -H "Sec-Fetch-Mode: navigate" -H "Sec-Fetch-Site: none" -H "Sec-Fetch-User: ?1" -H "TE: trailers" 2>/dev/null | head -n 1 | cut -d$' ' -f2)
echo -e "Test du cookie sur l'API MidJourney, statut de la réponse HTTP: ${cookietest}"
if [ "$cookietest" -eq 200 ]; then
    echo -e "${GREEN}Le cookie est valide${NC} \n"
    while [ -z "$user_id" ]
    do
      echo -e "\nEntrez l'${BLUE}UUID${NC} de l'user puis appuyez sur Entree "
      read my_uuid
      
      user_id=$(curl -s "https://www.midjourney.com/api/app/recent-jobs/?amount=1&dedupe=true&jobStatus=completed&minRankingScore=0&orderBy=new&prompt=undefined&refreshApi=0&searchType=advanced&service=null&userId={$my_uuid}&user_id_ranked_score=0,4,5&_ql=todo&_qurl=https://www.midjourney.com/app/users/{$my_uuid}/" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" -H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "Alt-Used: www.midjourney.com" -H "Connection: keep-alive" -H "Cookie: {$my_cookie}" -H "Upgrade-Insecure-Requests: 1" -H "Sec-Fetch-Dest: document" -H "Sec-Fetch-Mode: navigate" -H "Sec-Fetch-Site: none" -H "Sec-Fetch-User: ?1" -H "TE: trailers" --compressed | grep -oP '(?<="username":")[^"]*' | tr '/.' '-'| tr -d '[:space:]')
    if [ -z "$user_id" ]; then
      echo -e "\n${RED}L'UUID entré est incorrect ou l'user n'existe pas. Veuillez réessayer.${NC}"
    else
      echo -e "\n${GREEN}Cet UUID est valide et correspond à l'user ${BLUE}${user_id}${NC}${GREEN} à la date du ${date}${NC}\n \n"
      echo -e "${GREEN}Interrogation de l'API et récupération des 2000 derniers prompts de ${BLUE}${user_id}${NC}${GREEN} s'ils existent \n${NC}"

      #changer seq en seq 0 50

      seq 0 50 | xargs -I {} curl "https://www.midjourney.com/api/app/recent-jobs/?amount=50&page={}&dedupe=true&jobStatus=completed&minRankingScore=0&orderBy=new&prompt=undefined&refreshApi=0&searchType=advanced&service=null&userId={$my_uuid}&user_id_ranked_score=0,4,5&_ql=todo&_qurl=https://www.midjourney.com/app/users/{$my_uuid}/" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" -H "Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3" -H "Accept-Encoding: gzip, deflate, br" -H "Alt-Used: www.midjourney.com" -H "Connection: keep-alive" -H "Cookie: {$my_cookie}" -H "Upgrade-Insecure-Requests: 1" -H "Sec-Fetch-Dest: document" -H "Sec-Fetch-Mode: navigate" -H "Sec-Fetch-Site: none" -H "Sec-Fetch-User: ?1" -H "TE: trailers" --compressed >> infos_${user_id}_${date}.txt
      cat infos_${user_id}_${date}.txt | grep -oP '(?<="prompt":")[^"]*' > prompts_${user_id}_${date}.txt
      echo -e "\n\n${GREEN}Sauvegarde${NC} des prompts de  ${BLUE}${user_id}${NC} dans un fichier ${BLUE}prompts_${user_id}_${date}${NC}"
      ##echo -e "Recuperation des ${GREEN}dates de generation${NC} \n"
      cat infos_${user_id}_${date}.txt | grep -oP '(?<="enqueue_time":")[^.]*' > dates_${user_id}_${date}.txt
      echo -e "${GREEN}Sauvegarde${NC} des dates de generation dans un fichier ${BLUE}dates_${user_id}_${date}${NC} "
      ##echo -e "\n_____________________________________\n"
      ##echo -e "${GREEN}Fusion${NC} des fichiers de prompts et de dates en un fichier CSV"
      paste -d ';' prompts_${user_id}_${date}.txt dates_${user_id}_${date}.txt > resultats_${user_id}_${date}.csv
      echo -e "${GREEN}Sauvegarde${NC} de la compilation prompts+dates dans un fichier ${BLUE}resultats_${user_id}_${date}.csv${NC}"
      lignes=$(wc -l resultats_${user_id}_${date}.csv | cut -d ' ' -f 1)
      echo -e "\n_____________________________________\n \n \n${GREEN}SUCCES nous avons pu récupérer ${BLUE}${lignes}${NC}${GREEN} prompts au total !${NC} \n"
    fi
    done
else
  echo "Le cookie n'est pas valide, nous vidons le fichier cookie.txt, veuillez rentrer un cookie valide lors de la prochaine demande ou copier-coller un cookie valide dans cookie.txt"
  truncate -s 0 cookie.txt
fi

