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
	replicates: set Partition
}

sig Broker {
	-- Can store 0 or more replicas
	stores: set Replica
}


/* Replicas of the same parition cannot be 
stored on the same broker */
//pred replicaOfSamePartitionOnDiffBrokers {
//	all p: Partition, disj r1, r2: (replicates.p) |
//		disj[stores.r1, stores.r2]
//}


/***********************
 * Pairwise Constraints 
 ***********************/

/* One Partition instance */
run constraint1 {
	#replicates = 0
	#stores = 0
}

// Inconsistent
run constraint2 {
	#replicates = 0
	#stores = 1
}

// Inconsistent
run constraint3 {
	#replicates = 0
	#stores >= 2
}

// Simple Replica -> Parition
run constraint4 {
	#replicates = 1
	#stores = 0
}

// Simple Broker->Replica -> Parition
run constraint5 {
	#replicates = 1
	#stores = 1
}

// 2 brokers storing same replica: Illegal instance
run constraint6 {
	#replicates = 1
	#stores >= 2
}

run constraint7 {
	#replicates >= 2
	#stores = 0
}

run constraint8 {
	#replicates >= 2
	#stores = 1
}

// Same kind of illegal instance
run constraint9 {
	#replicates >= 2
	#stores >= 2
}
