pro process_rhessi, position=position

	loadct, 0
	!p.color=0
	!p.background=150
	window, 0, xs=1000, ys=600


	search_network, /enable		; To enable online searches
	use_network
	t0=anytim('2003-11-18T07:30:00', /utim)
	t1=anytim('2003-11-18T09:30:00', /utim)
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
	
	;--------------------------------------;
	;
	;		Attenuator correction
	;
	;atten_t0 = anytim('2003-11-18T08:46:00', /utim)
	;atten_t1 = anytim('2003-11-18T09:15:00', /utim)
	;atten0_i = where(times_rate gt atten_t0 and times_rate lt atten_t1)
	;correction0  = data_0[atten0_i[0]-30]/data_0[atten0_i[0]+30]
	;data_0[atten0_i] = data_0[atten0_i]*correction0

	;correction1  = data_1[atten0_i[0]-30]/data_1[atten0_i[0]+30]
	;data_1[atten0_i] = data_1[atten0_i]*correction1

	;atten0_i = where(times_rate gt atten_t0)
	;correction2  = data_2[atten0_i[0]-30]/data_2[atten0_i[0]+30]
	;data_2[atten0_i] = data_2[atten0_i]*correction2

	;atten_t0 = anytim('2003-11-18T08:51:12', /utim)
	;atten_t1 = anytim('2003-11-18T09:10:36', /utim)
	;atten0_i = where(times_rate gt atten_t0 and times_rate lt atten_t1)
	;correction0  = data_0[atten0_i[0]-30]/data_0[atten0_i[0]+36]
	;data_0[atten0_i] = data_0[atten0_i]*correction0 + 200

	;atten_t0 = anytim('2003-11-18T08:59:01', /utim)
	;atten_t1 = anytim('2003-11-18T09:04:21', /utim)
	;atten0_i = where(times_rate gt atten_t0 and times_rate lt atten_t1)
	;correction0  = data_0[atten0_i[0]-30]/data_0[atten0_i[0]+36]
	;data_0[atten0_i] = data_0[atten0_i]*correction0 -100.

	;correction  = data_1[atten0_i[0]-30]/data_1[atten0_i[0]+36]
	;data_1[atten0_i] = data_1[atten0_i] + 50.0
	;data_1[atten0_i] = data_1[atten0_i]*correction 

	;atten_t0 = anytim('2003-11-18T09:15:00', /utim)
	;atten0_i = where(times_rate gt atten_t0)
	;data_1[atten0_i] = data_1[atten0_i]*8.0
	;data_0[atten0_i] = data_0[atten0_i]*50.0
	

	;--------------------------------------;
	;
	;		Remove jumps
	;
	data_deriv = abs(deriv(data_0))
	bad_indices = where(data_0 gt 1000)

	for i=0, n_elements(bad_indices)-1 do begin
		bad_index = bad_indices[i]
		data_0[bad_index] = data_0[bad_index-20]
		data_1[bad_index] = data_1[bad_index-20]
		data_2[bad_index] = data_2[bad_index-20]
	endfor	
	;data_0 = smooth(data_0, 10)
	;data_1 = smooth(data_1, 10)
	;data_2 = smooth(data_2, 10)



	yrange=[1e-2, 1e4]
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

	outplot, times_rate, data_0, color=10, thick=3

	outplot, times_rate, data_1, color=0, thick=4
	outplot, times_rate, data_1, color=8, thick=3

	outplot, times_rate, data_2, color=0, thick=4
	outplot, times_rate, data_2, color=4, thick=3

	i1 = obj->get(/info)
	energies = i1.energy_edges

	legend, ['RHESSI 6-12 keV', 'RHESSI 12-25 keV', 'RHESSI 25-50 keV'], $
		color = [10, 8, 4], $
		linestyle = intarr(3), $
		box=0, $
		charsize=1.0, $
		textcolors = 0, $
		/left, $
		/normal, $
		thick=3	

	save, times_rate, data_0, data_1, data_2, filename='~/Data/2003_nov_18/RHESSI/rhessi_20011118.sav'
	;plot, times_rate, smooth(data_0, 5), /nodata, /ylog, XTICKFORMAT="(A1)", YTICKFORMAT="(A1)", yticklen=-1, pos = [0.929, 0.15, 0.93, 0.7], /normal, /noerase
	;axis, yaxis=1, yr=yrange, color=0, charsize=1.0, yticklen=-1e-1, ytitle='RHESSI Count Rate (s!U-1!N detector!U-1!N)', /ylog

stop
end