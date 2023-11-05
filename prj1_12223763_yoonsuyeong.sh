#! /bin/bash

#매개변수 개수 확인
if [ $# -ne 3 ]; then
  echo "사용법: ./test.sh u.item u.data u.user"
  exit 1
fi

item="./$1"
data="./$2"
user="./$3"

func1() {
	echo ""
	read -p "Please enter 'movie id' (1~1682) :" mId
	echo ""
	cat $item | awk -v num=$mId 'NR==num {print $0}'
	echo ""
}

func2(){
	echo ""
	read -p "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n): " YESNO
	echo ""
	if [ $YESNO = "y" ]; then
		cat $item | awk -F '|' '$7==1 {print $1, $2}' | head -n 10
	fi
	echo ""
}

func3(){
	echo ""
	read -p "Please enter 'movie id' (1~1682) :" mId
	
	local sum=$(cat $data | awk -v num=$mId '$2==num {sum+=$3} END {print sum}')
	local count=$(cat $data | awk -v num=$mId '$2==num {count++} END {print count}')


	echo ""
	echo "$sum $count" | awk -v num=$mId '{printf("average rating of %d: %g\n\n", num, $1/$2)}'
}

func4(){
	echo ""
	read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n):" YESNO
	echo""
	if [ $YESNO = "y" ]; then
		cat $item | sed -E 's/(.*)\|(.*)\|(.*)\|\|(.*)\|([01\|]{37})/\1\|\2\|\3\|\|\|\5/' | head -n 10
	fi
	echo""
}

func5(){
	echo ""
	read -p "Do you want to get the data about users from 'u.user'?(y/n):" YESNO
	echo""
	if [ $YESNO = "y" ]; then
		cat $user | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)\|(.*)/user \1 is \2 years old \3 \4/' | sed -E 's/M/male/' | sed -E 's/F/female/' | head -n 10
	fi
	echo""
}

func6(){
	echo ""
	read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n):" YESNO
	echo""
	if [ $YESNO = "y" ]; then
		cat $item | sed -E 's/\-(Jan)/\-01/g; s/\-(Feb)/\-02/g; s/\-(Mar)/\-03/g; s/\-(Apr)/\-04/g; s/\-(May)/\-05/g; s/\-(Jun)/\-06/g; s/\-(Jul)/\-07/g; s/\-(Aug)/\-08/g; s/\-(Sep)/\-09/g; s/\-(Oct)/\-10/g; s/\-(Nov)/\-11/g; s/\-(Dec)/\-12/g' | sed -E 's/([0-9]{2})-([0-9]{2})-([0-9]{4})/\3\2\1/g' | tail -n 10
	fi
	echo""
}

func7(){
	echo ""
	read -p "Please enter the ‘user id’(1~943):" uId
	echo""	

	cat $data | awk -v num=$uId '$1==num {print $2}' | sort -n | awk '{printf("%d | ", $1)}'
	mvs=$(cat $data | awk -v num=$uId '$1==num {print $2}' | sort -n | head -n 10)
	
	echo ""
	echo ""
	for i in $mvs
	do
		cat $item | awk -F '|' -v num=$i 'num==$1{printf("%d | %s", $1, $2)}'
		echo ""
	done	
	echo ""
}

func8(){
	echo ""
	read -p "Do you want to get the average 'rating' ofmovies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" YESNO
	echo""

	if [ $YESNO = "y" ]; then
		programmers20s=$(cat $user | awk -F '|' '$2>=20 && $2<30 && $4=="programmer" {print $1}' | sort -n | uniq)
	fi
	
	ratedMovie=""
	for programmersId in $programmers20s
	do
		ratedData+=$(cat $data | awk -v pId=$programmersId '$1==pId {printf("\n%s"), $0}')
	done

	for i in $(seq 1 1682)
	do
		local sum=$(echo "$ratedData" | awk -v num=$i '$2==num {print $0}' | awk '{sum+=$3} END {print sum}')
		local count=$(echo "$ratedData" | awk -v num=$i '$2==num {print $0}' | wc -l)
		if [ "$count" = "0" ];
		then
			continue
		else
			echo "$i $sum $count" | awk '{printf("%d %g\n", $1, $2/$3)}'
		fi
	done
	echo ""
}

func9(){
	echo "Bye!"
	exit 1
}


echo "--------------------------"
echo "User Name: Yoonsuyeong" 
echo "Student Number: 12223763"

echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

while true
do
	read -p "Enter your choice [ 1-9 ] " choice
	case $choice in
		1)
		func1
		;;
		2)
		func2
		;;
		3)
		func3
		;;
		4)
		func4
		;;
		5)
		func5
		;;
		6)
		func6
		;;
		7)
		func7
		;;
		8)
		func8
		;;
		9)
		func9
		;;
	esac
done

