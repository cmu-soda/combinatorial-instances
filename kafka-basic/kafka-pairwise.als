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
	-- Replicates a single partition
	replicates: one Partition
}

sig Broker {
	-- Can store 0 or more replicas
	-- 2 brokers cannot store the SAME replica
	stores: disj set Replica
}


/* Replicas of the same parition cannot be 
stored on the same broker */
pred replicaOfSamePartitionOnDiffBrokers {
	all p: Partition, disj r1, r2: (replicates.p) |
		disj[stores.r1, stores.r2]
}

/** global constraints **/
fact globalFact {
	replicaOfSamePartitionOnDiffBrokers
}


/***********************
 * Pairwise Constraints 
 ***********************/

/* Shows completely detached signature instances 
of Partition and Broker signatures
Note: No replica instances shown because of the 
`replicates: one Partition` constraint in Replica’s signature. */
run constraint1 {
	#replicates = 0
	#stores = 0
}

/* Inconsistent predicates: Replicas cannot exist with 
#replicates=0 due to `replicates: one Partition` constraint 
in Replica’s signature. #stores=1 is not possible since 
there are no replicas */
run constraint2 {
	#replicates = 0
	#stores = 1
}

/* Inconsistent predicates: Replicas cannot exist with 
#replicates=0 due to `replicates: one Partition` 
constraint in Replica’s signature. #stores >= 2 
is not possible since there are no replicas */
run constraint3 {
	#replicates = 0
	#stores >= 2
}

/* Exactly one simple Replica->Partition relation seen. 
Going next will show "Orphaned" Brokers and 
other Partitions */
run constraint4 {
	#replicates = 1
	#stores = 0
}


/* Simple Broker --stores--> Replica --replicates--> Partition 
instance seen. Going next will show other detached objects. */
run constraint5 {
	#replicates = 1
	#stores = 1
}

/* Inconsistent predicates: Exactly one replica exists with 
#replicates=1 due to `replicates: one Partition`. #stores>=2 
is not possible with one replica as multiple brokers cannot 
store the same replica due to the `disj` in 
`stores: disj set Replica`. */
run constraint6 {
	#replicates = 1
	#stores >= 2
}

/* Shows 2 replicas in replicates (related to the same partition). 
Going next also shows 2+ replicas in replicates 
(belonging to multiple 2+ partitions) */
run constraint7 {
	#replicates >= 2
	#stores = 0
}

/* Similar to constraint 7, but with one Broker that stores a 
replica. */
run constraint8 {
	#replicates >= 2
	#stores = 1
}

/* Similar to constrinat8, but shows 3 replicas and brokers.
Each replica is stored in a broker even though there’s no 
constraint that requires all to be stored. All are stored in 
different brokers because of the global fact 
`replicaOfSamePartitionOnDiffBrokers` */
run constraint9 {
	#replicates >= 2
	#stores >= 2
}
