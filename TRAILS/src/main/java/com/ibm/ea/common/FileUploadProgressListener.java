package com.ibm.ea.common;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.ProgressListener;

import com.ibm.ea.common.State.EStatus;

public class FileUploadProgressListener implements ProgressListener {

	private HttpSession session;

	private static final String LABEL = "FILEUPLOAD";

	public FileUploadProgressListener(HttpServletRequest request) {
		this.session = request.getSession();
	}

	public void update(long readedBytes, long totalBytes, int currentItem) {

		@SuppressWarnings("unchecked")
		List<State> steps = (List<State>) session
				.getAttribute(State.ATTR_STEPS);

		if (steps == null) {
			steps = new ArrayList<State>();
			session.setAttribute(State.ATTR_STEPS, steps);
		}

		State state = State.findStateByLable(steps, LABEL);

		if (state == null) {
			state = new State();
			state.setLabel(LABEL);
			state.setDescription("File upload");
			state.setStatus(EStatus.IN_PROGRESS);
			steps.add(state);
		}

		int progress = (int) ((float) readedBytes / totalBytes * 100);
		state.setProgress(progress);

		if (progress == 100) {
			state.setStatus(EStatus.FINISHED);
		}
	}

}
