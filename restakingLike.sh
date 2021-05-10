#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DELEGATOR='your delegator address'
VALIDATOR='your valoper address'
PASWD='password to your wallet'
DELAY=7200 #in secs
ACC_NAME=validator

for (( ;; )); do
	BAL=$(docker exec likechain_liked likecli query account ${DELEGATOR} --chain-id "likecoin-chain-sheungwan");
        echo -e "BALANCE: ${GREEN}${BAL}${NC} nanolike\n"
	echo -e "Claim rewards\n"
	echo -e "${PASWD}\n${PASWD}\n" | docker exec likechain_liked likecli tx distribution withdraw-rewards ${VALIDATOR} --chain-id "likecoin-chain-sheungwan" --from ${ACC_NAME} --node tcp://liked:26657  --commission -y -o json
	for (( timer=10; timer>0; timer-- ))
	do
		printf "* sleep for ${RED}%02d${NC} sec\r" $timer
		sleep 1
	done
	BAL=$(docker exec likechain_liked likecli query distribution validator-outstanding-rewards ${VALIDATOR} --chain-id "likecoin-chain-sheungwan" -o json | jq -r '.value.coins[].amount');
	echo -e "BALANCE: ${GREEN}${BAL}${NC} nanolike\n"
	echo -e "Stake ALL\n"
	echo -e "${PASWD}\n${PASWD}\n" | docker exec likechain_liked likecli tx staking delegate ${VALIDATOR} ${BAL}nanolike --chain-id "likecoin-chain-sheungwan" --from ${ACC_NAME} --node tcp://liked:26657 -y -o json | jq .
	for (( timer=${DELAY}; timer>0; timer-- ))
	do
		printf "* sleep for ${RED}%02d${NC} sec\r" $timer
		sleep 1
	done
done
