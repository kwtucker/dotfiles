#!/bin/bash

# Function specific for bash shell
# function kcs() {
	# lab=alpha.k8s.aort.theplatform.com
	# prod=alpha.k8s.aort.theplatform.com

	# if [[ $1 == "prod" ]]; then
		# kubectl config use-context $prod 
		# kubectl get pods	
		# return
	# elif [[ $1 == "lab" ]]; then
		# kubectl config use-context $lab 
		# kubectl get pods	
		# return 	
	# fi

	# contexts=($(kubectl config get-contexts | awk '{print $2}'))
	
	# printf "\nContexts\n\n" 

	# j=1
	# for i in "${contexts[@]:1}"
	# do
		# echo $j") "$i
		# ((j++))
	# done
	
	# echo
	# read -e -p 'Select your context and press [ENTER]: ' selection 
	# echo	

	# # un signed ints match 
  # re='^[0-9]+([.][0-9]+)?$'
	
	# # If the selection is equal to a number and greater than 0. 
	# if [[ $selection =~ $re && $selection -gt 0 ]]; then
		# context=`echo ${contexts[$selection]} | cut -d " " -f1`
		# if [[ $context != "" ]]; then
			# kubectl config use-context $context 
			# kubectl get pods	
			# echo
			# return
		# fi
	# fi

	# # Defualt to Lab
	# echo "Selection Not Valid ${selection}"
	# printf "\nSelecting Lab Cluster"
	# kubectl config use-context $lab 
	# echo
	# kubectl get pods	
	# echo
# }
