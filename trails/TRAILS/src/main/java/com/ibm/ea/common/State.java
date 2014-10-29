package com.ibm.ea.common;

import java.util.List;

public class State {

	public static final String ATTR_STEPS = "psteps";

	private String label;
	private String description;
	private int progress;
	private EStatus status;
	private boolean finalState;

	public enum EStatus
	{

		FAILED(3),
		ERROR(4),
		FINISHED(2),
		IN_PROGRESS(1),
		IGNORED(1),
		SUCCESS(5);

		private int priority;

		private EStatus(int priority) {
			this.priority = priority;
		}

		public int getPriority() {
			return priority;
		}

	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getProgress() {
		return progress;
	}

	public void setProgress(int progress) {
		this.progress = progress;
	}

	public EStatus getStatus() {
		return status;
	}

	public void setStatus(EStatus status) {
		this.status = status;
	}

	public boolean isFinalState() {
		return finalState;
	}

	public void setFinalState(boolean finalState) {
		this.finalState = finalState;
	}

	public static State findStateByLable(List<State> steps, String label) {
		for (State state : steps) {
			if (state.getLabel().equals(label)) {
				return state;
			}
		}
		return null;
	}

	public void setFinalStatus(List<State> steps) {
		for (State s : steps) {
			if (s.getStatus() != EStatus.FINISHED) {
				setStatus(EStatus.FAILED);
				return;
			}
		}
		setStatus(EStatus.SUCCESS);
	}
}
