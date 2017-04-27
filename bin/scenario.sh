echo "+ Deleting any existing fifo"

\rm /tmp/in_*_??? /tmp/out_*_??? 2> /dev/null
# Cleanup function to kill processes and remove fifos

cleanup () {
	# Killing all Airplug applications
	kill $lst_procs 2> /dev/null

	# In case some tee processes still exist
	killall tee 2> /dev/null

	# Removing fifos
	\rm -f $lst_fifos
	exit 0
}
# Calling the cleanup function when the script terminates

echo "+ Catching signals"
trap cleanup INT QUIT TERM
# Starting processes
echo "+ Starting processes with their fifos"
#  The list of nodes is the first command line argument.
lst_nodes=$1
#  List of processes id
lst_procs=""
#  List of fifos
lsg_fifos=""
#  i is used for counting, j is used for positioning the HLG windows.
i=0
j=50
for id in $lst_nodes; do
	# Counting + geometry
	let "i= i+1"
	let "j=j+50"

	# Creating and storing fifos
	mkfifo /tmp/in_${id}_bas /tmp/out_${id}_bas 2> /dev/null
	lst_fifos="$lst_fifos /tmp/in_${id}_bas /tmp/out_${id}_bas"
	mkfifo /tmp/in_${id}_hlg /tmp/out_${id}_hlg 2> /dev/null
	lst_fifos="$lst_fifos /tmp/in_${id}_hlg /tmp/out_${id}_hlg"
	# Starting the BAS application (iconified)

	# First line: Airplug libraries options; second line: BAS options.
	./bas.tk --whatwho --verbose=-1 --auto --ident=$id --begin=HLG \
			 --dest=HLG --delay=1000 < /tmp/in_${id}_bas > /tmp/out_${id}_bas &
	lst_procs="$lst_procs $!"

	# Starting the HLG application
	./hlg.tk --whatwho --verbose=-1 --auto --ident=$id --begin=BAS \
		< /tmp/in_${id}_hlg > /tmp/out_${id}_hlg &

	lst_procs="$lst_procs $!"
done
# Setting the connections

echo "+ Setting the connection"
for id in $lst_nodes; do
	#Creating a partial list with all the nodes except id
	lst_nodes_p=${lst_nodes/$id}

	# Link from the BAS to the HLG
	cat /tmp/out_${id}_bas > /tmp/in_${id}_hlg &
	lst_procs="$lst_procs $!"
	
	# Link from the HLG to all the HLG
	com="cat /tmp/out_${id}_hlg | tee /tmp/in_${id}_bas"

	#Adding the HLG to the command com
	for id_i in $lst_nodes_p; do
		com="$com /tmp/in_${id_i}_hlg"	
	done
	com="$com &"	
	eval $com
	lst_procs="$lst_procs $!"
done

echo "  Scenario with $i nodes organized is running"
# Starting a sleep waiting for Ctrl C...

echo "+ Waiting for Crtl C during 1h..."
sleep 3600
cleanup


