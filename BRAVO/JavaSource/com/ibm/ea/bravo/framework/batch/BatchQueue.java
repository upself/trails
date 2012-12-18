package com.ibm.ea.bravo.framework.batch;

import java.util.LinkedList;




/**
 * 
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BatchQueue {

	private static LinkedList<IBatch> q = new LinkedList<IBatch>();

	public void addBatch(IBatch batch)  {
		q.add(batch);
	}

	public IBatch getBatch()  {
		if (q.isEmpty()) {
			return null;
		}
		return (IBatch) q.getFirst();
	}

	public boolean isEmpty()   {
		return q.isEmpty();
	}

	public IBatch popBatch()  {
		if (q.isEmpty())
			return null;
		
		return (IBatch) q.removeFirst();
	}
}