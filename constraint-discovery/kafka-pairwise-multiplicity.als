open util/relation

/**
 * A subset of Kafka model
 * -----------------------
 *
 * Signatures
 * > Partition: A single topic partition in Kafka
 * > Replica: A replica of a partition
 * > Broker: A server where a replica can be stored
 *
 * No other constraints
 */

sig Partition {}

sig Replica {
	-- Replicates a single partition
	replicates: Partition
}

sig Broker {
	-- Can store 0 or more replicas
	stores: Replica
}


/* Replicas of the same parition cannot be 
stored on the same broker */
//pred replicaOfSamePartitionOnDiffBrokers {
//	all p: Partition, disj r1, r2: (replicates.p) |
//		disj[stores.r1, stores.r2]
//}

/** Multiplicity helper predicates **/
pred isOneOne[r: univ->univ] {
	#dom[r] = 1
	#ran[r] = 1
}

pred isOneMany[r: univ->univ] {
	#dom[r] = 1
	#ran[r] = 2
}

pred isManyOne[r: univ->univ] {
	#dom[r] = 2
	#ran[r] = 1
}

pred isManyMany[r: univ->univ] {
	#dom[r] = 2
	#ran[r] = 2
}

/***********************
 * Pairwise Constraints 
 ***********************/

run constraint1 {
	isOneOne[replicates]
	isOneOne[stores]
}

run constraint2 {
	isOneOne[replicates]
	isOneMany[stores]
}

// illegal: 2 broker 1 replica
run constraint3 {
	isOneOne[replicates]
	isManyOne[stores]
}


run constraint4 {
	isOneOne[replicates]
	isManyMany[stores]
}

run constraint5 {
	isOneMany[replicates]
	isOneOne[stores]
}

run constraint6 {
	isOneMany[replicates]
	isOneMany[stores]
}

run constraint7 {
	isOneMany[replicates]
	isManyOne[stores]
}

run constraint8 {
	isOneMany[replicates]
	isManyMany[stores]
}


run constraint9 {
	isManyOne[replicates]
	isOneOne[stores]
}

run constraint10 {
	isManyOne[replicates]
	isOneMany[stores]
}

// same
run constraint11 {
	isManyOne[replicates]
	isManyOne[stores]
}

run constraint12 {
	isManyOne[replicates]
	isManyMany[stores]
}

run constraint13 {
	isManyMany[replicates]
	isOneOne[stores]
}

run constraint14 {
	isManyMany[replicates]
	isOneMany[stores]
}

run constraint15 {
	isManyMany[replicates]
	isManyOne[stores]
}

run constraint16 {
	isManyMany[replicates]
	isManyMany[stores]
}
