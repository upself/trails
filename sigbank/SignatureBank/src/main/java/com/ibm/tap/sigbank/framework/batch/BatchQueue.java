package com.ibm.tap.sigbank.framework.batch;

import java.util.LinkedList;

/**
 * 
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BatchQueue {

	// TODO LOW Implement as database table
	// private static Vector q = new Vector();
	private static LinkedList<IBatch> q = new LinkedList<IBatch>();

	// public void addBatch(IBatch batch) throws TorqueException,
	// DataSetException, SQLException, IOException {
	// TrailsWriteDelegate.addBatch(batch);
	// }
	//
	// public IBatch getBatch() throws TorqueException, IOException,
	// ClassNotFoundException, SQLException {
	// return TrailsReadDelegate.getBatch();
	// }
	//
	// public boolean isEmpty() throws TorqueException {
	// return TrailsReadDelegate.isBatchQueueEmpty();
	// }
	//
	// public IBatch popBatch() throws TorqueException, IOException,
	// ClassNotFoundException, SQLException {
	// return TrailsWriteDelegate.popBatch();
	//
	// }
	//
	// public static List getQ() throws TorqueException, IOException,
	// ClassNotFoundException, SQLException {
	// return TrailsReadDelegate.getBatchQueue();
	// }

	public void addBatch(IBatch batch) {
		q.add(batch);
	}

	public IBatch getBatch() {
		if (q.isEmpty()) {
			return null;
		}
		return (IBatch) q.getFirst();
	}

	public boolean isEmpty() {
		return q.isEmpty();
	}

	public IBatch popBatch() {
		return (IBatch) q.removeFirst();
	}

	// public static List getQ() {
	// return TrailsReadDelegate.getBatchQueue();
	// }

}