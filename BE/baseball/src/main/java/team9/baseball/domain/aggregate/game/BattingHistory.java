package team9.baseball.domain.aggregate.game;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import team9.baseball.domain.aggregate.team.Team;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class BattingHistory {
    @Id
    private Long id;

    private Integer batterTeamId;

    private Integer batterUniformNumber;

    private int appear;

    private int hits;

    private int out;

    public BattingHistory(Integer batterTeamId, Integer batterUniformNumber) {
        this.batterTeamId = batterTeamId;
        this.batterUniformNumber = batterUniformNumber;
    }

    public static String acquireKeyInGame(Integer batterTeamId, Integer batterUniformNumber) {
        return batterTeamId + "_" + batterUniformNumber;
    }

    public double getHitRatio() {
        double hitRatio = 0;
        if (this.appear != 0) {
            hitRatio = (double) this.hits / (double) this.appear;
        }
        return hitRatio;
    }

    public boolean hasMatchingTeamId(Team team) {
        return this.batterTeamId == team.getId();
    }

    public String getStatus() {
        return String.format("%d타석 %d안타", this.appear, this.hits);
    }

    public void plusAppear() {
        this.appear++;
    }

    public void plusHits() {
        this.hits++;
    }

    public void plusOut() {
        this.out++;
    }
}
