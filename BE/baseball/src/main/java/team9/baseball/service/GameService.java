package team9.baseball.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import team9.baseball.DTO.response.GameDescriptionDTO;
import team9.baseball.DTO.response.GameHistoryDTO;
import team9.baseball.DTO.response.GameStatusDTO;
import team9.baseball.domain.aggregate.game.Game;
import team9.baseball.domain.aggregate.team.Team;
import team9.baseball.domain.aggregate.user.User;
import team9.baseball.domain.enums.PitchResult;
import team9.baseball.domain.enums.Venue;
import team9.baseball.exception.NotFoundException;
import team9.baseball.repository.GameRepository;
import team9.baseball.repository.TeamRepository;
import team9.baseball.repository.UserRepository;

import java.util.List;

@Service
public class GameService {
    private final GameRepository gameRepository;
    private final TeamRepository teamRepository;
    private final UserRepository userRepository;

    @Autowired
    public GameService(GameRepository gameRepository, TeamRepository teamRepository, UserRepository userRepository) {
        this.gameRepository = gameRepository;
        this.teamRepository = teamRepository;
        this.userRepository = userRepository;
    }

    public void applyPitchResult(long userId, PitchResult pitchResult) {
        User user = getUser(userId);
        if (user.getCurrentGameId() == null) {
            throw new RuntimeException(userId + "사용자는 게임중이 아닙니다.");
        }
        Game game = getGame(user.getCurrentGameId());
        Team awayTeam = getTeam(game.getAwayTeamId());
        Team homeTeam = getTeam(game.getHomeTeamId());

        //현재 내가 공격팀이면 공을 던질 수 없다.
        if (game.getCurrentHalves() == user.getCurrentGameVenue().getHalves()) {
            throw new RuntimeException(userId + "번 사용자는 현재 공격팀입니다.");
        }

        switch (pitchResult) {
            case HIT:
                game.proceedHit(awayTeam, homeTeam);
                break;
            case STRIKE:
                game.proceedStrike(awayTeam, homeTeam);
                break;
            case BALL:
                game.proceedBall(awayTeam, homeTeam);
                break;
        }
        gameRepository.save(game);
    }

    public GameStatusDTO getCurrentGameStatus(long userId) {
        User user = getUser(userId);
        if (user.getCurrentGameId() == null) {
            throw new RuntimeException(userId + "사용자는 게임중이 아닙니다.");
        }
        Game game = getGame(user.getCurrentGameId());
        Team awayTeam = getTeam(game.getAwayTeamId());
        Team homeTeam = getTeam(game.getHomeTeamId());

        return GameStatusDTO.of(game, awayTeam, homeTeam, user.getCurrentGameVenue());
    }

    public GameHistoryDTO getCurrentGameHistory(long userId) {
        User user = getUser(userId);
        if (user.getCurrentGameId() == null) {
            throw new RuntimeException(userId + "사용자는 게임중이 아닙니다.");
        }
        Game game = getGame(user.getCurrentGameId());
        Team awayTeam = getTeam(game.getAwayTeamId());
        Team homeTeam = getTeam(game.getHomeTeamId());

        return GameHistoryDTO.of(game, awayTeam, homeTeam);
    }

    public void createNewGame(long userId, int awayTeamId, int homeTeamId) {
        User user = getUser(userId);
        Team awayTeam = getTeam(awayTeamId);
        Team homeTeam = getTeam(homeTeamId);

        Game game = new Game(awayTeam, homeTeam);
        game = gameRepository.save(game);
    }

    public void joinGame(long userId, long gameId, Venue venue) {
        User user = getUser(userId);
        if (user.getCurrentGameId() != null) {
            throw new RuntimeException(userId + "사용자는 이미 게임중입니다.");
        }
        Game game = getGame(gameId);
        if (userRepository.existsByCurrentGameIdAndCurrentGameVenue(gameId, venue)) {
            throw new RuntimeException(gameId + "번 게임의 " + venue + "팀은 다른 사용자가 참가했습니다.");
        }

        user.setCurrentGameId(gameId);
        user.setCurrentGameVenue(venue);
        userRepository.save(user);
    }

    public List<GameDescriptionDTO> getAllGameList() {
        return gameRepository.findAllGameDescription();
    }

    private User getUser(long userId) {
        return userRepository.findById(userId).orElseThrow(() -> new NotFoundException(userId + " 사용자는 존재하지 않습니다."));
    }

    private Game getGame(long gameId) {
        return gameRepository.findById(gameId).orElseThrow(() -> new NotFoundException(gameId + "번 게임은 존재하지 않습니다."));
    }

    private Team getTeam(int teamId) {
        return teamRepository.findById(teamId).orElseThrow(() -> new NotFoundException(teamId + "번 팀은 존재하지 않습니다."));
    }
}
