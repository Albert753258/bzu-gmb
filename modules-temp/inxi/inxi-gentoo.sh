#!/bin/bash

#проверяем что модуль запущен от пользователя root
[ "$UID" -eq 0 ] || { zenity --error --text="Этот скрипт нужно запускать из под root!"; exit 1;}

# определение имени файла, папки где находиться скрипт и версию скрипта
name_script0=`basename "$0"`
name_script=`echo ${name_script0} | sed "s|.sh||g"`
#echo ${name_script}
script_dir0=$(cd $(dirname "$0") && pwd); name_cut="/modules-temp/${name_script}"
#echo ${name_cut}
#echo ${script_dir0}
script_dir=`echo ${script_dir0} | sed "s|${name_cut}||g"`
version0=`cat "${script_dir}/config/name_version"`
version="${version0}"

#объявляем нужные переменные для скрипта
date_install=`date`

#даем информацию в терминал какой модуль устанавливается
tput setaf 2; echo "Установка утилиты INXI для сбора информации о оборудовании вашего ПК\ноутбука в консоли [https://github.com/smxi/inxi]. Версия скрипта 1.0, автор: Яцына М.А."
tput sgr0

#запуск основных команд модуля
sudo -S emerge x11-terms/xterm || let "error += 1"
sudo -S emerge sys-apps/inxi || let "error += 1"

module_installing=`eix-installed -a | grep sys-apps/inxi` || true
if [[ "${module_installing}" == "" ]]
then
tput setaf 1; echo "При установки inxi произошла ошибка!"  || let "error += 1"
tput sgr0
else
tput setaf 2; echo "Статуст установки inxi: ${module_installing}"
tput sgr0
#тестовый запуск Lutris
xterm -hold -maximized -e inxi -Fxs & sleep 5;sudo -S killall xterm
fi

#добавляем информацию в лог установки о уровне ошибок модуля, чем выше цифра, тем больше было ошибок и нужно проверить модуль разработчику
echo "модуль ${name_script}, дата установки:${date_install}, количество ошибок:${error}"	 				  >> "${script_dir}/module_install_log"

#Добавляем информацию о изменении флагов в файле настройки GRUB в лог установки
echo "для использования inxi в терминале"	 				  >> "${script_dir}/module_install_log"
echo "наберите: inxi -Fxs"	 				  >> "${script_dir}/module_install_log"

#echo "например в steam:"	 				  >> "${script_dir}/module_install_log"
#echo "gamemoderun %command%"	 				  >> "${script_dir}/module_install_log"
#echo "Подробнее о командах и функциях тут: https://github.com/FeralInteractive/gamemode"	 				  >> "${script_dir}/module_install_log"


#задержка вывода информации о итогах установки, что бы пользователь мог ознакомиться.

exit 0
