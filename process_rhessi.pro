pro process_rhessi, position=position, save=save

	loadct, 0
	!p.color=0
	!p.background=150
	window, 0, xs=1000, ys=600


	search_network, /enable		; To enable online searches
	use_network
	t0=anytim('2003-11-18T08:00:00', /utim)
	t1=anytim('2003-11-18T08:50:00', /utim)
	t0_rhessi = anytim(t0, /atimes)
	t1_rhessi = anytim(t1, /atimes)

	obj = hsi_obs_summary()
	obj -> set, obs_time_interval=[t0_rhessi, t1_rhessi]
	d1 = obj -> getdata(/corrected)
	data = d1.countrate
	times_rate = obj -> getaxis(/ut) 

	set_line_color

	en_index = 1
	data_0 = data[en_index, *]
	data_1 = data[en_index+1, *]
	data_2 = data[en_index+2, *]
	

	yrange=[1e1, 1e4]
	utplot, times_rate, data_0, $
			thick = 4, $
			color = 0, $
			/xs, $ 
			/ys, $
			/ylog, $
			xr=anytim([t0, t1], /utim), $
			yr = yrange, $
			xtitle=' ', $
			ytitle='RHESSI Count Rate (s!U-1!N detector!U-1!N)', $
			;xtickformat='(A1)', $
			;ytickformat='(A1)', $
			xticklen = 1.0, xgridstyle = 1.0, $
			;yticklen = 1.0, ygridstyle = 1.0, $
			;position = position, $
			/noerase, $
			/normal

	outplot, times_rate, data_0, color=8, thick=3

	outplot, times_rate, data_1, color=0, thick=4
	outplot, times_rate, data_1, color=4, thick=3

	outplot, times_rate, data_2, color=0, thick=4
	outplot, times_rate, data_2, color=10, thick=3

	i1 = obj->get(/info)
	energies = i1.energy_edges

	legend, ['RHESSI 6-12 keV', 'RHESSI 12-25 keV', 'RHESSI 25-50 keV'], $
		color = [8, 4, 10], $
		linestyle = intarr(3), $
		box = 0, $
		charsize = 1.0, $
		textcolors = 0, $
		/left, $
		/normal, $
		thick=3	

	if keyword_set(save) then save, times_rate, data_0, data_1, data_2, filename='~/Data/2003_nov_18/RHESSI/rhessi_20011118.sav'
	;plot, times_rate, smooth(data_0, 5), /nodata, /ylog, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", yticklen=-1, pos = [0.929, 0.15, 0.93, 0.7], /normal, /noerase
	;axis, yaxis=1, yr=yrange, color=0, charsize=1.0, yticklen=-1e-1, ytitle='RHESSI Count Rate (s!U-1!N detector!U-1!N)', /ylog

stop
end