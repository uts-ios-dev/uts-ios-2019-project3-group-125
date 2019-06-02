//
//  MTHelper.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation
import UIKit

/// 取消任务Block
public typealias CancelableTask = (_ cancel: Bool) -> ()


/// 延迟执行事件
///
/// - Parameters:
///   - time: 延迟时间
///   - work: 执行事件
/// - Returns: 取消 see `CancelableTask`
@discardableResult
public func delay(_ time: TimeInterval, work: @escaping ()->()) -> CancelableTask? {

	var finalTask: CancelableTask?

	let cancelableTask: CancelableTask = { cancel in
		if cancel {
			finalTask = nil // key
		} else {
			DispatchQueue.main.async(execute: work)
		}
	}

	finalTask = cancelableTask

	DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
		if let task = finalTask {
			task(false)
		}
	}

	return finalTask
}


/// 取消执行
public func cancel(_ cancelableTask: CancelableTask?) {
	cancelableTask?(true)
}


