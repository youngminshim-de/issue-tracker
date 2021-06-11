package team02.issue_tracker.dto.issue;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;
import team02.issue_tracker.domain.Issue;
import team02.issue_tracker.domain.IssueAssignee;
import team02.issue_tracker.domain.IssueLabel;
import team02.issue_tracker.dto.LabelResponse;
import team02.issue_tracker.dto.UserResponse;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@AllArgsConstructor
@Getter
public abstract class AbstractIssueResponse {

    private Long id;
    private int issueNumber;
    private String title;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")
    private LocalDateTime createdTime;

    private Boolean isOpen;
    private UserResponse writer;
    private List<UserResponse> assignees;
    private List<LabelResponse> labels;

    public AbstractIssueResponse(Issue issue) {
        this.id = issue.getId();
        this.issueNumber = issue.getIssueNumber();
        this.title = issue.getTitle();
        this.createdTime = issue.getCreatedTime();
        this.isOpen = issue.isOpen();
        this.writer = new UserResponse(issue.getWriter());
        this.assignees = toAssigneeResponses(issue.getIssueAssignees());
        this.labels = toLabelResponses(issue.getIssueLabels());
    }

    private List<UserResponse> toAssigneeResponses(List<IssueAssignee> issueAssignees) {
        return issueAssignees.stream()
                .map(IssueAssignee::getAssignee)
                .map(UserResponse::new)
                .collect(Collectors.toList());
    }

    private List<LabelResponse> toLabelResponses(List<IssueLabel> issueLabels) {
        return issueLabels.stream()
                .map(IssueLabel::getLabel)
                .map(LabelResponse::new)
                .collect(Collectors.toList());
    }
}
