extends CanvasLayer

func set_score_text(score):
	%Score.text = str(score)

func set_time_text(time):
	%Time.text = "%.1f s" % time
