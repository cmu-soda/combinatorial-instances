/**
 * A subset of Kafka model
 * -----------------------
 *
 * Signatures
 * > Partition: A single topic partition in Kafka
 * > Replica: A replica of a partition
 * > Broker: A server where a replica can be stored
 *
 * Relations
 * > replicates | many-to-one | Replica* --replicates--> !Parition
 * > stores			| one-to-many | Broker! --stores--> *Replica
 *
 * Additional Constraints
 * > Same replica cannot be stored in multiple brokers
 *   - Expressed by adding `disj` to the relation `stores`
 *
 * > No two replicas of the same patition can be stored a single broker
 *   - Expressed in `replicaOfSamePartitionOnDiffBrokers`
 *   - Included in fact `globalFact`
 */

sig Partition {}

sig Replica {
	// Replicates a single partition
	replicates: one Partition
}

sig Broker {
	// Can store 0 or more replicas
	// 2 brokers cannot store the SAME replica
	stores: disj set Replica
}


// replicas of the same parition cannot be stored on the same broker
pred replicaOfSamePartitionOnDiffBrokers {
	all p: Partition, disj r1, r2: (replicates.p) |
		disj[stores.r1, stores.r2]
}

// global constraints
fact globalFact {
	replicaOfSamePartitionOnDiffBrokers
}


/** Pairwise Constraints **/
run constraint1 {
	#replicates = 0
	#stores = 0
}

run constraint2 {
	#replicates = 0
	#stores = 1
}

run constraint3 {
	#replicates = 0
	#stores >= 2
}

run constraint4 {
	#replicates = 1
	#stores = 0
}

run constraint5 {
	#replicates = 1
	#stores = 1
}

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

run constraint9 {
	#replicates >= 2
	#stores >= 2
}
